;; Increase gc threshold, this makes lsp and company mode work better.
;; 100mb
(setq gc-cons-threshold 100000000)

;; Pinentry fixes popups in terminals for gpg
(setq epa-pinentry-mode 'loopback)

;; Setup packages
(setq package-archives
              '(("gnu"         . "http://elpa.gnu.org/packages/")
                ("org"         . "http://orgmode.org/elpa/")
                ("melpa"       . "http://melpa.org/packages/")
                ("marmalade"   . "http://marmalade-repo.org/packages/")))
(package-initialize)

;; Setup emacs path, use package, and set custom file location
(eval-when-compile
  (defun emacs-path (path)
      (expand-file-name path user-emacs-directory)))

(eval-when-compile
  (unless (package-installed-p 'use-package)
    (package-install 'use-package))
  (require 'use-package))

(setq custom-file (emacs-path "custom.el"))

;; Mac os x requires exec path from shell to be run early.
(use-package exec-path-from-shell
  :ensure t
  :demand t
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

;; Load encrypted configuration
(org-babel-load-file (emacs-path "config.org.gpg"))

;; Alphabetized use packages

(use-package base16-theme
  :ensure t
  :demand t
  :config
  (setq base16-highlight-mode-line 'contrast)
  (setq base16-theme-256-color-source 'base16-shell)
  (load-theme 'base16-solarized-dark t))

(use-package company
  :ensure t
  :demand t
  :bind (("C-<tab>" . counsel-company))
  :config (global-company-mode 1))

(use-package counsel
  :after ivy
  :ensure t
  :bind (("C-x C-f" . counsel-find-file)
	 ("C-c i" . counsel-imenu)
	 ("C-c g" . counsel-git)
	 ("C-c j" . counsel-git-grep)
	 ("C-c k" . counsel-ag)
	 ("C-c p" . counsel-yank-pop))
  :config (counsel-mode 1))

(use-package counsel-projectile
  :after (counsel projectile)
  :ensure t
  :config
  (counsel-projectile-mode))

(setq evil-want-C-i-jump nil)

(setq evil-esc-delay 0)

(use-package evil
  :ensure t
  :demand t
  :config
  (evil-mode 1))

(use-package evil-surround
  :after evil
  :ensure t
  :demand t
  :config
  (global-evil-surround-mode 1))

(use-package flycheck
  :ensure t)

(use-package flyspell
  :hook ((text-mode . flyspell-mode)
	 (prog-mode . flyspell-prog-mode)))

(use-package glsl-mode
  :ensure t
  :mode (("\\.glsl\\'" . glsl-mode)
	 ("\\.vert\\'" . glsl-mode)
	 ("\\.frag\\'" . glsl-mode)
	 ("\\.geom\\'" . glsl-mode)))

(use-package ivy
  :ensure t
  :bind (("C-x b" . ivy-switch-buffer)
	 ("C-c v" . ivy-push-view)
	 ("C-c V" . ivy-pop-view))
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-count-format "(%d/%d) ")
  (ivy-mode 1))

(use-package lsp-mode
  :ensure t
  :commands lsp
  :init (setq lsp-keymap-prefix "C-;")
  :bind (:map lsp-command-map ("d" . xref-find-definitions))
  :config
  (setq rustic-lsp-server 'rust-analyzer)
  (setq lsp-rust-rls-server-command '(rust-analyzer))
  (setq lsp-rust-analyzer-cargo-all-targets t))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
	 ("C-x M-g" . magit-dispatch-popup)))

(use-package paredit
  :ensure t
  :hook (emacs-lisp-mode . paredit-mode))

(use-package projectile
  :after counsel
  :ensure t
  :bind (("C-c p" . projectile-command-map))
  :config
  (setq projectile-mode-line
	'(:eval (format " Projectile[%s]"
			(projectile-project-name))))
  (setq projectile-completion-system 'counsel)
  (setq projectile-switch-project-action 'counsel-projectile)
  (projectile-mode +1))

;; This installed markdown mode, projectile
(use-package rustic
  :after projectile
  :ensure t
  :hook ((rustic-mode . electric-pair-mode)
	 (rustic-mode . auto-revert-mode)))

(use-package smart-mode-line
  :ensure t
  :demand t
  :config
  (setq sml/no-confirm-load-theme t)
  (setq sml/theme 'respectful)
  (sml/setup))

(use-package swiper
  :after ivy
  :ensure t
  :bind ("C-s" . swiper))

(use-package writegood-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package yasnippet
  :ensure t
  :bind (("C-c y d" . yas-load-directory)
         ("C-c y i" . yas-insert-snippet)
         ("C-c y f" . yas-visit-snippet-file)
         ("C-c y n" . yas-new-snippet)
         ("C-c y t" . yas-tryout-snippet)
         ("C-c y l" . yas-describe-tables)
         ("C-c y g" . yas/global-mode)
         ("C-c y m" . yas/minor-mode)
         ("C-c y r" . yas-reload-all)
         ("C-c y x" . yas-expand))
  :config
  (yas-load-directory (emacs-path "snippets"))
  (yas-global-mode 1))

;; Larger configuration files written in org mode
(org-babel-load-file (emacs-path "bindings.org"))
(org-babel-load-file (emacs-path "mail.org"))
(org-babel-load-file (emacs-path "misc.org"))
(org-babel-load-file (emacs-path "org.org"))

(server-start)
