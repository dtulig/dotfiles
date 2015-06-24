(setq org-directory (expand-file-name "~/Dropbox/org"))

(setq org-log-done 'time)
(global-set-key "\C-cl" 'org-store-link)
(setq org-default-notes-file (concat org-directory "/notes.org"))
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-refile-use-outline-path 'nil)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

(setq org-clock-in-resume t)
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
(setq org-clock-into-drawer t)
(setq org-clock-out-remove-zero-time-clocks t)
(setq org-clock-out-when-done t)

(setq org-capture-templates
      '(("t" "Todo" entry (file+datetree
                            (concat org-directory "/inbox.org")) 
         "* TODO %^{Description}
%U
%?
" :clock-in t :clock-resume t)
        ("r" "Respond" entry (file+datetree
                              (concat org-directory "/inbox.org"))
               "* NEXT Respond to %^{From} on %^{Subject}
SCHEDULED: %t
%U
%?
" :clock-in t :clock-resume t :immediate-finish t)
        ("n" "Note" entry (file+datetree
                           (concat org-directory "/inbox.org"))
               "* %? :NOTE:
%U
" :clock-in t :clock-resume t)
        ("j" "Journal" entry (file+datetree (concat org-directory "/journal.org"))
               "* %^{Title}
%U
%?
" :clock-in t :clock-resume t)
        ("l" "Log Time" entry (file+datetree
                               (concat org-directory "/timelog.org")) 
         "** %U - %^{Activity}  :TIME:")
        ("m" "Meeting" entry (file+datetree
                              (concat org-directory "/inbox.org"))
               "* MEETING with %^{Description} :MEETING:
%U
%?" :clock-in t :clock-resume t)))

(setq org-refile-targets (quote ((nil :maxlevel . 3)
                                 (org-agenda-files :maxlevel . 3))))

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq org-agenda-files (list (expand-file-name "~/Dropbox/org")))

(setq org-agenda-span 'day)

(add-hook 'org-agenda-mode-hook
          (lambda ()
            (add-hook 'auto-save-hook 'org-save-all-org-buffers nil t)
            (auto-save-mode)))

(require 'cl)

(defun buffer-major-mode-org-mode-p (buffer)
  (string= "org-mode" (with-current-buffer buffer major-mode)))

;; When refreshing the org mode window, occasionally a file will have
;; shifted underneath the current instance of emacs. This function
;; will close all org-mode buffers.
(defun org-close-all-org-buffers ()
  (interactive)
  (mapcar #'kill-buffer
          (remove-if-not #'buffer-major-mode-org-mode-p (buffer-list))))

;; This is a global key to close all org mode buffers.
(global-set-key "\C-c\C-g" 'org-close-all-org-buffers)

(defun org-agenda-redo-with-close-buffers ()
  (interactive)
  (org-close-all-org-buffers)
  (org-agenda-redo t))

;: This remaps "g" to close all org mode buffers and then call agenda
;; redo. "r" still calls redo normally.
(add-hook 'org-agenda-mode-hook
          (lambda ()
            (define-key org-agenda-mode-map "g" #'org-agenda-redo-with-close-buffers)))



