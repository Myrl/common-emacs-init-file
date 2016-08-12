
(global-set-key (kbd "C-c i") 'my-jump-to-init-file)
(defun my-jump-to-init-file ()
  (interactive)
  (find-file "~/.emacs"))

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(blink-cursor-mode 0)
(fset 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-screen t)
(setq initial-scratch-message "")

(when (eq system-type 'darwin)
  (setq visible-bell nil)
  (setq ring-bell-function 'ignore))
(setq vc-follow-symlinks t)
(winner-mode)
(windmove-default-keybindings)

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

(package-initialize)

(unless (locate-library "use-package")
  (package-refresh-contents)
  (package-install 'use-package)
  (package-install 'helm))

(require 'use-package)

(setq-default truncate-lines t)
(setq ielm-prompt "ielm> ")
(setq find-function-C-source-directory
      "~/my-tech-downloads/emacs-24.5/src")
(add-to-list 'auto-mode-alist '(".mdwn" . markdown-mode))

;; (use-package xscheme)
;; (setq scheme-root 
(setq scheme-program-name "/usr/local/bin/scheme")

(setq python-indent-offset 4)
(setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i")

(unless (eq system-type 'darwin)
  (use-package badger-theme
    :ensure t
    :config (load-theme 'badger t)))

(use-package magit
  :ensure t
  :config (setq magit-popup-show-common-commands nil)
  :bind ("C-x g" . magit-status))

(use-package helm-config
  :ensure helm
  :bind (("C-x C-f" . helm-find-files)
	 ("C-x b" . helm-buffers-list)
	 ("C-x l" . helm-bookmarks)))

(global-set-key (kbd "C-x C-b") 'ibuffer-other-window)

(global-set-key (kbd "C-x O") (lambda ()
                                (interactive)
                                (other-window -1)))

(use-package bookmark+ :ensure t)
(defun my-bookmark-list ()
  (interactive)
  (pop-to-buffer (bookmark-bmenu-list)))
(global-set-key (kbd "C-c r l") 'my-bookmark-list)

(use-package haskell-mode
  :ensure t
  :config
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (add-hook 'haskell-mode-hook 'haskell-indentation-mode)
  (setq haskell-interactive-popup-errors nil)
  (bind-key "C-c C-l" 'my-save-and-haskell-load haskell-mode-map)
  (defun my-save-and-haskell-load ()             
    (interactive)
    (with-current-buffer (current-buffer)
      (save-buffer)
      (haskell-process-load-file))))

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(setq dired-auto-revert-buffer t)
(setq dired-omit-files "^\\.?#")
(use-package dired-x
  :config (add-hook 'dired-mode-hook 'dired-hide-details-mode))

;; (load-theme 'badger t)

(use-package nlinum
  :ensure t
  :config (add-hook 'prog-mode-hook 'nlinum-mode))

(use-package yasnippet
  :ensure t
  :config (yas-global-mode nil))

(global-set-key (kbd "C-c y") 'load-theme)
(global-set-key (kbd "C-c Y") 'customize-themes)

(use-package evil
  :ensure t
  :config (define-key evil-normal-state-map ";" 'evil-ex)
  :bind (("C-c w H" . evil-window-move-far-left)
         ("C-c w J" . evil-window-move-very-bottom)
         ("C-c w K" . evil-window-move-very-top)
         ("C-c w L" . evil-window-move-far-right)
         ("C-c v" . evil-mode)))

(use-package evil-escape
  :ensure t
  :config
  (setq-default evil-escape-key-sequence "jk")
  (evil-escape-mode))

(use-package todotxt
  :ensure t
  :config
  (setq todotxt-file todotxt-file) ; don't forget :)
  (setq todotxt-use-creation-dates nil)
  :bind ("C-x t" . todotxt))

(bind-keys ("M-<down>"  . enlarge-window)
           ("M-<up>"    . shrink-window)
           ("M-<left>" . shrink-window-horizontally-4)
           ("M-<right>"  . enlarge-window-horizontally-4))

(defun shrink-window-horizontally-4 ()
  (interactive)
  (shrink-window-horizontally 4))
(defun enlarge-window-horizontally-4 ()
  (interactive)
  (enlarge-window-horizontally 4))

(bind-keys ("C-S-e" . scroll-up-line)
           ("C-S-y" . scroll-down-line))

(autoload 'calendar-date-string "calendar")
(defun insert-date-N-days-from-current (&optional days)
  "Insert date that is DAYS from current."
  (interactive "P*")
  (insert
   (calendar-date-string
    (if days
        (calendar-gregorian-from-absolute
         (+ (calendar-absolute-from-gregorian (calendar-current-date))
            days))
      (calendar-current-date)))))
(global-set-key (kbd "C-c d") 'insert-date-N-days-from-current)

(setq org-cycle-separator-lines 0)
(setq org-blank-before-new-entry
      '((heading . nil)
	(plain-list-item . nil)))

(setq calendar-latitude 47.6)
(setq calendar-longitude -122.3)
(setq calendar-location-name "Seattle, WA")

(setq org-entities-user '(("vdots" "\\vdots" nil "&#8230" "|" "⋮" "⋮")))

(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c C-l") 'org-insert-link)

(add-hook 'org-mode-hook 'auto-fill-mode)

(setq org-agenda-timegrid-use-ampm t)
(setq org-cycle-separator-lines 0)
(setq org-blank-before-new-entry '((heading) (plain-list-item)))
(setq org-src-fontify-natively t)
(setq org-edit-src-content-indentation 0)

(setq org-return-follows-link t)
(setq org-use-speed-commands t)
(setq org-speed-commands-user '((";" . org-set-tags-command)))
(setq org-fast-tag-selection-single-key t)
(setq org-special-ctrl-a/e t)
(setq org-special-ctrl-k t)

;; (add-hook 'org-shiftup-final-hook 'windmove-up)
;; (add-hook 'org-shiftleft-final-hook 'windmove-left)
;; (add-hook 'org-shiftdown-final-hook 'windmove-down)
;; (add-hook 'org-shiftright-final-hook 'windmove-right)
;; (setq org-support-shift-select t)
;; (setq org-tags-column -70)

(setq org-src-tab-acts-natively t)
(setq org-src-fontify-natively t)
(setq org-export-allow-bind-keywords t)
(setq org-export-backends '(ascii html latex odt))
(require 'ob-haskell)
(setq org-highlight-latex-and-related '(latex entities))
;; (add-hook 'org '(require 'ox))
(eval-after-load "org-src"
  '(progn
     (add-to-list 'org-src-lang-modes '("dot" . graphviz-dot))
     (add-to-list 'org-src-lang-modes '("sage" . sage))
     (add-to-list 'org-src-lang-modes '("xml" . xml))
     ;; (add-to-list 'org-src-lang-modes '("xscheme" . xscheme))
     ;; (add-to-list 'org-src-lang-modes '("bash" . bash))
     (org-babel-do-load-languages
      'org-babel-load-languages
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
        ))))

(setq custom-file "~/.custom.el")
