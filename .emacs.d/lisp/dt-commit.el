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
  "Write a commit message for the staged diff.

Structure:
- Subject line: short summary of the change
- Optional body: blank line, then paragraphs explaining why

Subject rules:
- Imperative mood, as if completing 'If applied, this commit will ___'
  Good: `Add logging to connection pool`
  Bad:  `Added logging` / `Adds logging`
- Capitalize the first letter, no trailing period
- Aim for 50 characters, never exceed 72
- Summarize the *what*, not the *how*

Body rules (when warranted):
- Separate from subject with ONE blank line
- Explain *why* the change is being made and what problem it solves
- Do not hard-wrap; write flowing prose, one line per paragraph
- Use multiple paragraphs separated by blank lines if needed
- Skip the body for small, self-evident changes (typo fixes, renames, dep bumps)

Examples of BAD subjects:
  added new parser feature.          (past tense, lowercase, period)
  Update code                        (vague)
  refactor: extract validation       (no type prefixes)

Example of a good full message:

  Prevent race in connection pool shutdown

  The pool's shutdown path closed idle connections before marking the pool as closed, so a concurrent checkout could grab a connection that was about to be torn down. Flip the order: mark closed first, then drain. Checkout now sees the closed flag and returns an error instead of a doomed connection.

Output only the commit message. No ``` fences. No preamble or explanation."
  "System prompt for commit message generation.
Tuned for local models."
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
