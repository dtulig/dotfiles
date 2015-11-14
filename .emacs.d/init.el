;; Initialize Emacs config. This is the starting point for running
;; emacs.

;; Require the package module and add marmalade and melpa-stable. This
;; is used with package-list-packages to hook into the elpa
;; repository.
(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

;; Initialize the package manager.
(package-initialize)

;; If there isn't an archive of the contents, refresh.
(when (not package-archive-contents)
    (package-refresh-contents))

;; Make sure the following is installed in an emacs installation.
(defvar my-packages '(starter-kit
                      starter-kit-bindings
                      starter-kit-js
                      starter-kit-lisp
                      starter-kit-ruby
                      yasnippet
                      clojure-mode
                      clojurescript-mode
                      cider
                      auto-complete
                      ac-nrepl
                      go-mode
                      exec-path-from-shell
                      haskell-mode
                      ghc
                      flycheck
                      flycheck-haskell)
    "A list of packages to ensure are installed at launch.")

;; Install them.
(dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p)))

;; Setup the Solarized theme.
;; Need to run `git submodule update --init` to pull down the solarized
;; theme.
(add-to-list 'custom-theme-load-path "~/.emacs.d/non-elpa/emacs-color-theme-solarized")
(load-theme 'solarized t)

;; Show better el stack traces.
(setq stack-trace-on-error t)

;; Run when not on a mac.
(when (not (memq window-system '(mac ns)))
  ;; On linux machines, the font size is a bit small, this bumps it up
  ;; to something more readable. This makes it smaller on mac.
  (set-face-attribute 'default nil :height 110))

;; When on a mac, make sure to load exec-path-from-shell to get the
;; PATH loaded into emacs.
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; Put the non-elpa directory on the load path.
(add-to-list 'load-path "~/.emacs.d/non-elpa")

;; Tell Magit we're good for now.
(setq magit-last-seen-setup-instructions "1.4.0")

;; Load all el files from the src dir.
(setq config-src-dir (concat user-emacs-directory "src"))
(add-to-list 'load-path config-src-dir)
(when (file-exists-p config-src-dir)
    (mapc 'load (directory-files config-src-dir nil "^[^#].*el$")))

;;(require 'yasnippet) ;; not yasnippet-bundle
;;(yas/initialize)
;;(yas/load-directory "~/.emacs.d/elpa/yasnippet-0.6.1/snippets")

(custom-set-variables
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-layout-name "left7")
 '(ecb-layout-window-sizes (quote (("left7" (ecb-directories-buffer-name 0.15126050420168066 . 0.576271186440678) (ecb-history-buffer-name 0.15126050420168066 . 0.15254237288135594) (ecb-methods-buffer-name 0.15126050420168066 . 0.2542372881355932)))))
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote (("~/.emacs.d" "emacs"))))
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(safe-local-variable-values (quote ((auto-save-timeout . 10) (auto-save-interval . 20) (auto-save-visited-file-name . t) (whitespace-line-column . 80) (lexical-binding . t)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun unfill-paragraph (&optional region)
     "Takes a multi-line paragraph and makes it into a single line of text."
     (interactive (progn (barf-if-buffer-read-only) '(t)))
     (let ((fill-column (point-max))
           (emacs-lisp-docstring-fill-column t))
       (fill-paragraph nil region)))

(define-key global-map "\M-Q" 'unfill-paragraph)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
