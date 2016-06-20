
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
        ;; ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

(package-initialize)

(unless (locate-library "use-package")
  (package-refresh-contents)
  (package-install 'use-package)
  (package-install 'helm))

(winner-mode)
(setq-default truncate-lines t)
(windmove-default-keybindings)
(global-set-key (kbd "M-/") 'hippie-expand)

(global-set-key (kbd "C-c i") 'my-jump-to-init-file)
(defun my-jump-to-init-file ()
  (interactive)
  (find-file "~/.emacs"))

(setq python-indent-offset 4)
(setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i")

(use-package badger-theme
  :ensure t
  :config (load-theme 'badger t))

(use-package magit
  :ensure t
  :config
  (setq magit-popup-show-common-commands nil)
  :bind ("C-x g" . magit-status))

;; (ido-mode)
;; (ido-vertical-mode)
;; (require 'helm-config)
(use-package helm-config
  :ensure helm
  :bind (("C-x C-f" . helm-find-files)
	 ("C-x b" . helm-buffers-list)
	 ("C-x l" . helm-bookmarks))
  ;; :config
  ;; (global-set-key (kbd "C-x C-f") 'helm-find-files)
  ;; (global-set-key (kbd "C-x b") 'helm-buffers-list)
  ;; (global-set-key (kbd "C-x l") 'helm-bookmarks)
  )

(global-set-key (kbd "C-x C-b") 'ibuffer-other-window)

;; (require 'bookmark+)
(use-package bookmark+ :ensure t)
(defun my-bookmark-list ()
  (interactive)
  (pop-to-buffer (bookmark-bmenu-list)))
(global-set-key (kbd "C-c r l") 'my-bookmark-list)

(setq haskell-interactive-popup-errors nil)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(add-hook 'haskell-mode-hook 'haskell-indentation-mode)

(fset 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-screen t)
(setq initial-scratch-message "")
(setq vc-follow-symlinks t)

;; (require 'exec-path-from-shell)
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; (require 'dired-x)
(use-package dired-x
  :config
  (add-hook 'dired-mode-hook 'dired-hide-details-mode))

;; (load-theme 'badger t)


(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode nil))

(global-set-key (kbd "C-c y") 'load-theme)
(global-set-key (kbd "C-c Y") 'customize-themes)

;; (require 'evil)
(use-package evil
  :ensure t
  :config
  (global-undo-tree-mode 0)
  (global-set-key (kbd "C-c w H") 'evil-window-move-far-left)
  (global-set-key (kbd "C-c w J") 'evil-window-move-very-bottom)
  (global-set-key (kbd "C-c w K") 'evil-window-move-very-top)
  (global-set-key (kbd "C-c w L") 'evil-window-move-far-right))

(global-set-key (kbd "M-<down>") 'enlarge-window)
(global-set-key (kbd "M-<up>") 'shrink-window)
(global-set-key (kbd "M-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-<left>") 'shrink-window-horizontally)

(global-set-key (kbd "C-S-e") 'scroll-up-line)
(global-set-key (kbd "C-S-y") 'scroll-down-line)

(setq org-cycle-separator-lines 0)
(setq org-blank-before-new-entry
      '((heading . nil)
	(plain-list-item . nil)))

(org-babel-do-load-languages 'org-babel-load-languages
			     '(;; (bash . t)
			       (C . t)
			       ;; (css . t)
			       ;; (dot . t)
			       ;; (sage . t)
			       (emacs-lisp . t)
			       (haskell . t)
			       ;; (java . t)
			       (js . t)
			       (latex . t)
			       (ledger . t)
			       (makefile . t)
			       (org . t)
			       (python . t)
			       (scheme . t)
			       (sh . t)
			       ;; (xscheme . t)
			       ))

(load-file "~/my-cb-configs/.emacs")
(setq custom-file "~/my-cb-configs/.emacs")