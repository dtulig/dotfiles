;; https://github.com/dysinger/purescript-mode
;; make EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs all
;; M-x update-directory-autoloads
(add-to-list 'load-path "~/.emacs.d/non-elpa/purescript-mode")
(require 'purescript-mode-autoloads)
(add-hook 'purescript-mode-hook 'turn-on-purescript-indentation)
