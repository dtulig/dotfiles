(add-to-list 'load-path "~/.emacs.d/non-elpa/purescript-mode")
(require 'purescript-mode-autoloads)
(add-hook 'purescript-mode-hook 'turn-on-purescript-indentation)
