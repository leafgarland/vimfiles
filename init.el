(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq straight-use-package-by-default 1)
(straight-use-package 'use-package)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(global-prettify-symbols-mode 1)
(global-display-line-numbers-mode 1)
(show-paren-mode 1)
(set-default-coding-systems 'utf-8)
(setq
 scroll-margin 2
 cursor-in-non-selected-windows nil
 inhibit-startup-screen t
 initial-scratch-message ""
 indent-tabs-mode nil
 truncate-partial-width-windows nil
 truncate-lines 1
 tab-width 4
 frame-title-format '("%f" dired-directory)
 )

(use-package magit 
  :bind ("C-x g" . magit-status))

(use-package lispy
  :hook ((emacs-lisp-mode lisp-interaction-mode) . lispy-mode))

(use-package evil
  :config
  (evil-mode))

(use-package which-key
  :config (which-key-mode))

(use-package mood-line
  :config
  (mood-line-mode)
  (setq-default
   mode-line-format
   '((:eval
      (mood-line-format
       (format-mode-line
	'(
	  (:eval (mood-line-segment-modified))
	  (:eval (mood-line-segment-buffer-name))
	  (:eval (mood-line-segment-position))
	  ))
       (format-mode-line
	'(
	  (:eval (mood-line-segment-major-mode))
	  (:eval (mood-line-segment-global-mode-string))
	  (:eval (mood-line-segment-process))
	  " "
	  )))))))

(use-package brutalist-theme
  :config
  (load-theme 'brutalist 't)
  (custom-theme-set-faces
   'brutalist
   '(default ((t (:foundry "outline" :family "Iosevka" :background "#fffff8" :foreground "#111111" :height 110))))
   '(fixed-pitch ((t (:foundry "outline" :family "Iosevka"))))
   '(variable-pitch ((t (:foundry "outline" :family "Segoe UI"))))
   '(font-lock-string-face ((t (:inherit fixed-pitch :foreground "darkgreen" :background "#f8f8f0"))))
   '(font-lock-builtin-face ((t (:inherit fixed-pitch :slant italic))))
   '(mode-line ((t (:inherit fixed-pitch :background "#335EA8" :foreground "#85CEEB" :box (:line-width 8 :color "#335EA8")))))
   '(mode-line-inactive ((t (:background "#234E98" :foreground "#559EBB" :box (:line-width 8 :color "#234E98")))))
   '(mood-line-unimportant ((t (:foreground "#559EBB"))))
   '(mood-line-status-grayed-out ((t (:foreground "#458EAB"))))
   '(mood-line-status-info ((t (:foreground "#85CEEB"))))
   '(mood-line-modified ((t (:foreground "#FFD0CF"))))
   ))

(server-start)
