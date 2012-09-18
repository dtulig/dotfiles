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
                      ecb)
    "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
    (when (not (package-installed-p p))
          (package-install p)))

(setq stack-trace-on-error t)

(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs.d/elpa/yasnippet-0.6.1/snippets")

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
