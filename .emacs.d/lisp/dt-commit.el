;;; dt-commit.el --- Generate git commit messages with gptel -*- lexical-binding: t; -*-

;; Author: David Tulig
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1") (gptel "0.9.8"))
;; Keywords: vc, convenience, tools

;;; Commentary:

;; Generate git commit messages with gptel.  In a commit buffer,
;; M-x dt-commit-generate-message streams a message from the staged
;; diff.  Call `dt-commit-install' to bind it to M-g.

;;; Code:

(require 'gptel)
(require 'git-commit nil t)

(defgroup dt-commit nil
  "Generate git commit messages with an LLM."
  :group 'tools
  :prefix "dt-commit-")

(defcustom dt-commit-prompt
  "Write a Conventional Commits message for the staged diff.

Format: <type>(<scope>)?: <description>

Types (use exactly one): build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test.

Subject rules:
- Imperative mood: `add logging` not `added logging` or `adds logging`
- Lowercase description, no trailing period
- Aim for 50 characters, never exceed 72

Body (optional): blank line, then paragraphs explaining *why*. Do not hard-wrap lines - write flowing prose, one line per paragraph.

Examples of good subjects:
  feat(parser): support nested quoted strings
  fix: prevent race in connection pool shutdown
  refactor(api): extract request validation into middleware

Examples of BAD subjects (do not produce these):
  Added new parser feature.          (past tense, capitalized, period)
  Update code                        (vague, no type)
  feat: Added support for...         (capitalized after colon)

Output only the commit message. No ``` fences. No `Here is` preamble.
No explanation after the message."
  "System prompt for commit message generation.
Tuned for local models; see Conventional Commits spec."
  :type 'string
  :group 'dt-commit)

(defcustom dt-commit-model nil
  "Gptel model to use.  When nil, falls back to `gptel-model'."
  :type 'symbol
  :group 'dt-commit)

(defcustom dt-commit-backend nil
  "Gptel backend to use.  When nil, falls back to `gptel-backend'."
  :type '(choice (const :tag "Use default" nil) sexp)
  :group 'dt-commit)

(defcustom dt-commit-history-count 20
  "Number of recent commit subjects to include as style examples.
Set to 0 to disable."
  :type 'integer
  :group 'dt-commit)


;;; Internals

(defun dt-commit--git (&rest args)
  "Run git with ARGS and return stdout as a string, or nil on failure."
  (with-temp-buffer
    (let ((exit (apply #'call-process "git" nil (list t nil) nil args)))
      (and (zerop exit)
           (let ((s (buffer-string)))
             (and (not (string-empty-p (string-trim s))) s))))))

(defun dt-commit--staged-diff ()
  (dt-commit--git "diff" "--cached" "--no-color"))

(defun dt-commit--recent-subjects ()
  (when (> dt-commit-history-count 0)
    (dt-commit--git "log"
                    (format "-n%d" dt-commit-history-count)
                    "--pretty=format:%s")))

(defun dt-commit--build-prompt (diff)
  (let ((history (dt-commit--recent-subjects)))
    (if history
        (format "Recent commit subjects from this repository (for scope and style reference):

%s

Now write a commit message for the following staged diff:

%s"
                history diff)
      diff)))

(defun dt-commit--request (diff callback)
  "Send DIFF to gptel; CALLBACK is called as (CHUNK INFO)."
  (let ((gptel-backend (or dt-commit-backend gptel-backend))
        (gptel-model   (or dt-commit-model   gptel-model)))
    (gptel-request (dt-commit--build-prompt diff)
      :system dt-commit-prompt
      :stream t
      :callback callback)))


;;; Commands

;;;###autoload
(defun dt-commit-generate-message ()
  "Generate a commit message for the staged diff and insert it as it streams."
  (interactive)
  (unless (or (bound-and-true-p git-commit-mode)
              (and buffer-file-name
                   (string-match-p "COMMIT_EDITMSG\\'" buffer-file-name)))
    (user-error "Not in a git commit buffer"))
  (let ((diff (dt-commit--staged-diff)))
    (unless diff
      (user-error "No staged changes to summarize"))
    (let* ((target (current-buffer))
           (marker (with-current-buffer target
                     (copy-marker (point-min) t))))
      (message "dt-commit: streaming message...")
      (dt-commit--request
       diff
       (lambda (chunk info)
         (pcase chunk
           ((and (pred stringp) (guard (not (string-empty-p chunk))))
            (when (buffer-live-p target)
              (with-current-buffer target
                (save-excursion
                  (goto-char marker)
                  (insert chunk)))))
           ('t
            (set-marker marker nil)
            (message "dt-commit: done."))
           ((guard (equal (plist-get info :status) "error"))
            (set-marker marker nil)
            (message "dt-commit: %s"
                     (or (plist-get info :error) "generation failed.")))))))))

;;;###autoload
(defun dt-commit-install ()
  "Bind \\[dt-commit-generate-message] in `git-commit-mode'."
  (with-eval-after-load 'git-commit
    (define-key git-commit-mode-map (kbd "M-g") #'dt-commit-generate-message)))

(provide 'dt-commit)
;;; dt-commit.el ends here
