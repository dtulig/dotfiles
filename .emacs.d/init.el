(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages '(starter-kit
                      starter-kit-bindings
                      starter-kit-js
                      starter-kit-lisp
                      starter-kit-ruby
                      yasnippet
                      clojure-mode
                      clojure-test-mode
                      clojurescript-mode
                      cider
                      auto-complete
                      ac-nrepl
                      go-mode
                      exec-path-from-shell)
    "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
    (when (not (package-installed-p p))
          (package-install p)))

(setq stack-trace-on-error t)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

; Auto gofmt on save.
(add-hook 'before-save-hook 'gofmt-before-save)

;;(require 'yasnippet) ;; not yasnippet-bundle
;;(yas/initialize)
;;(yas/load-directory "~/.emacs.d/elpa/yasnippet-0.6.1/snippets")

;;; use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
(autoload 'groovy-mode "groovy-mode" "Major mode for editing Groovy code." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))
(add-to-list 'auto-mode-alist '("\.gradle$" . groovy-mode))

;;; make Groovy mode electric by default.
(add-hook 'groovy-mode-hook
          '(lambda ()
             (require 'groovy-electric)
             (groovy-electric-mode)))

(require 'term)
(defun visit-ansi-term ()
  "If the current buffer is:
     1) a running ansi-term named *ansi-term*, rename it.
     2) a stopped ansi-term, kill it and create a new one.
     3) a non ansi-term, go to an already running ansi-term
        or start a new one while killing a defunt one"
  (interactive)
  (let ((is-term (string= "term-mode" major-mode))
        (is-running (term-check-proc (buffer-name)))
        (term-cmd "/bin/bash")
        (anon-term (get-buffer "*ansi-term*")))
    (if is-term
        (if is-running
            (if (string= "*ansi-term*" (buffer-name))
                (call-interactively 'rename-buffer)
              (if anon-term
                  (switch-to-buffer "*ansi-term*")
                (ansi-term term-cmd)))
          (kill-buffer (buffer-name))
          (ansi-term term-cmd))
      (if anon-term
          (if (term-check-proc "*ansi-term*")
              (switch-to-buffer "*ansi-term*")
            (kill-buffer "*ansi-term*")
            (ansi-term term-cmd))
        (ansi-term term-cmd)))))
(global-set-key (kbd "<f2>") 'visit-ansi-term)

(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(require 'auto-complete-config)
(ac-config-default)

(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(setq nrepl-hide-special-buffers t)
(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook 'auto-complete-mode)

(setq org-directory (expand-file-name "~/Dropbox/org"))

(setq org-log-done 'time)
(global-set-key "\C-cl" 'org-store-link)
(setq org-default-notes-file (concat org-directory "/notes.org"))
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-refile-use-outline-path 'nil)

(setq org-capture-templates
      '(("t" "Personal Todo" entry (file+datetree
                           (concat org-directory "/personal.org")) 
         "* TODO %^{Description}  %^g
%?
Added: %U")
        ("w" "Indeed Todo" entry (file+datetree
                           (concat org-directory "/indeed.org")) 
         "* TODO %^{Description}  %^g
%?
Added: %U")
        ("i" "Inbox" entry (file+datetree
                            (concat org-directory "/inbox.org")) 
         "* TODO %^{Description}  %^g
%?
Added: %U")
        ("n" "Notes" entry (file+datetree
                            (concat org-directory "/inbox.org")) 
         "* %^{Description} %^g %? 
Added: %U")
        ("j" "Journal" entry (file+datetree
                              (concat org-directory "/journal.org"))
         "** %^{Heading}")
        ("l" "Log Time" entry (file+datetree
                               (concat org-directory "/timelog.org")) 
         "** %U - %^{Activity}  :TIME:")))

(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq org-agenda-files (list (expand-file-name "~/Dropbox/org")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-layout-name "left7")
 '(ecb-layout-window-sizes (quote (("left7" (ecb-directories-buffer-name 0.15126050420168066 . 0.576271186440678) (ecb-history-buffer-name 0.15126050420168066 . 0.15254237288135594) (ecb-methods-buffer-name 0.15126050420168066 . 0.2542372881355932)))))
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote (("~/.emacs.d" "emacs")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

