;;; init.el
;;
;; Set's the dotfiles directory to the init.el file, loads the
;; literate emacs.org file. This requires org mode and babel to
;; already be installed.

(setq dotfiles-dir
      (file-name-directory (or load-file-name (buffer-file-name))))

(org-babel-load-file (expand-file-name "emacs.org" dotfiles-dir))
(put 'downcase-region 'disabled nil)
