
(global-set-key (kbd "C-c i") 'my-jump-to-init-file)
(defun my-jump-to-init-file ()
  (interactive)
  (find-file "~/.emacs"))

(when (window-system)
  (tool-bar-mode 0)
  (scroll-bar-mode 0))
(menu-bar-mode 0)
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
(global-auto-revert-mode)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 5) ((control))))
(setq mouse-wheel-progressive-speed nil)

(defun google (query-string)
  (interactive "MEnter search query: ")
  (browse-url (url-encode-url
               (format "https://www.google.com/search?q=%s"
                       (replace-regexp-in-string " " "+" query-string)))))
(global-set-key (kbd "C-x G") 'google)

(setq package-archives
      '(
        ("gnu" . "https://elpa.gnu.org/packages/")
        ;; ("org" . "http://orgmode.org/elpa/")
        ("marmalade" . "https://marmalade-repo.org/packages/")
	("melpa-stable" . "https://melpa-stable.milkbox.net/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ))

(package-initialize)

(unless (locate-library "use-package")
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-defer t)

(use-package lua-mode
  :ensure t
  :defer t)

(use-package pdf-tools
  :ensure t
  :demand t
  :config
  (setenv "PKG_CONFIG_PATH" "/usr/local/Cellar/zlib/1.2.8/lib/pkgconfig:/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig")
  ;; (setenv "PKG_CONFIG" "/usr/local/Cellar/pkg-config/0.29.1_1/bin/pkg-config")

  (add-hook 'pdf-view-mode-hook 'pdf-outline-minor-mode)
  (add-hook 'pdf-view-mode-hook 'pdf-isearch-minor-mode)
  (setq pdf-view-use-dedicated-register nil)
  (add-to-list 'auto-mode-alist
               '("\\.\\(?:PDF\\|DVI\\|OD[FGPST]\\|DOCX?\\|XLSX?\\|PPTX?\\|pdf\\|djvu\\|dvi\\|od[fgpst]\\|docx?\\|xlsx?\\|pptx?\\)\\'"
                 . pdf-view-mode)
               ))

(add-hook 'pdf-outline-buffer-mode-hook 'toggle-truncate-lines)

(eval-after-load "pdf-view"
  '(bind-keys :map pdf-view-mode-map
	      ("j" . pdf-view-next-line-or-next-page)
	      ("k" . pdf-view-previous-line-or-previous-page)
	      ;; ("l" . image-forward-hscroll)
	      ;; ("h" . image-backward-hscroll)
	      ("l" . my-scroll-left)
	      ("h" . my-scroll-right)))

;; (eval-after-load "doc-view"
;;   '(bind-keys :map doc-view-mode-map
;; 	      ("j" . doc-view-next-line-or-next-page)
;; 	      ("k" . doc-view-previous-line-or-previous-page)
;; 	      ;; ("l" . image-forward-hscroll)
;; 	      ;; ("h" . image-backward-hscroll)
;; 	      ("l" . my-scroll-left)
;; 	      ("h" . my-scroll-right)))

(setq-default truncate-lines t)
(setq ielm-prompt "ielm> ")
(setq find-function-C-source-directory
      "~/my-tech-downloads/emacs-24.5/src")
(add-to-list 'auto-mode-alist '(".mdwn" . markdown-mode))

;; (setq mwheel-scroll-up-function (lambda (amt) (interactive) (scroll-up 1)))
;; (setq mwheel-scroll-down-function (lambda (amt) (interactive) (scroll-down 1)))

(when (eq system-type 'darwin)
  (global-set-key (kbd "<wheel-left>") 'my-scroll-left)
  (global-set-key (kbd "<wheel-right>") 'my-scroll-right))

(defun my-scroll-left ()
  (interactive)
  (scroll-left 1))
(defun my-scroll-right ()
  (interactive)
  (scroll-right 1))

;; (use-package xscheme)
;; (setq scheme-root 
;; (setq scheme-program-name "/usr/local/bin/scheme")

(setq scheme-program-name "/usr/local/bin/racket")
(add-to-list 'auto-mode-alist '(".rkt" . racket-mode))

(use-package autoinsert)
;; (add-to-list 'auto-insert-alist
(define-auto-insert "\\.rkt" '(insert "#lang racket\n\n"))

(setq python-indent-offset 4)
(setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i")

;; (eval-after-load "python"
;;   (lambda ()
;;     (when (require 'virtualenvwrapper nil t)
;;       (venv-initialize-interactive-shells))))

(use-package python
  :defer t
  :config
  ;; (add-hook 'python-mode-hook 'flycheck-mode)
  ;; (add-hook 'python-mode-hook 'my-disable-pylint)
  ;; (remove-hook 'python-mode-hook 'flycheck-mode)
  ;; (remove-hook 'python-mode-hook 'my-disable-pylint)
  )

;; (setq python-mode-hook '(wisent-python-default-setup))

(defun my-disable-pylint ()
  (interactive)
  (setq flycheck-disabled-checkers '(python-pylint)))
  

(use-package flycheck
  :ensure t
  :no-require t
  :defer t
  ;; :config
  ;; (flycheck-add-next-checker 'python-flake8 'python-pylint)
  )

;; (defun python-shell-parse-command ()
;;   "Return the string used to execute the inferior Python process."
;;   "/usr/local/bin/python3 -i")
;; (setq venv-location "~/.virtualenvs")

(unless (eq system-type 'darwin)
  (use-package badger-theme
    :ensure t
    :config (load-theme 'badger t)))

(use-package magit
  :ensure t
  :config (setq magit-popup-show-common-commands nil)
  :bind ("C-x g" . magit-status))

(setq set-mark-command-repeat-pop t)

;; unbind C-x <left/right>
;; (use-package back-button
;;   :ensure t
;;   :config
;;   (back-button-mode))

;; (setq register-preview-delay 0)
;; (use-package register-list
;;   :ensure t
;;   :bind ("C-x r v" . register-list))

(use-package helm-config
  :ensure helm
  :bind (("C-x C-f" . helm-find-files)
	 ("C-x b" . helm-buffers-list)
	 ("C-x l" . helm-bookmarks)
         ("C-x v" . helm-register)
         ;; ("C-x m" . helm-mark-ring)
         ))

(use-package ibuffer
  :bind ("C-x C-b" . ibuffer-other-window
         ;; ibuffer
         ))
;; (setq ibuffer-default-sorting-mode 'filename/process)

;; (add-hook 'ibuffer-mode-hook
;;   (lambda ()
;;     (ibuffer-switch-to-saved-filter-groups "default")))

(setq ibuffer-show-empty-filter-groups nil)

(setq ibuffer-saved-filter-groups nil)
  ;; (quote (("default"      
  ;;           ("Org" ;; all org-related buffers
  ;;             (mode . org-mode))  
  ;;           ("MyProject1"
  ;;             (filename . "src/myproject1/"))
  ;;           ("MyProject2"
  ;;             (filename . "src/myproject2/"))
  ;;           ("Programming" ;; prog stuff not already in MyProjectX
  ;;             (or
  ;;               (mode . c-mode)
  ;;               (mode . perl-mode)
  ;;               (mode . python-mode)
  ;;               (mode . emacs-lisp-mode)
  ;;               ;; etc
  ;;               )) ))))

 ;; '(ibuffer-saved-filter-groups
 ;;   (quote
 ;;    (("hello"
 ;;      ("minibuffer-inactive-mode"
 ;;       (mode . minibuffer-inactive-mode))
 ;;      ("help-mode"
 ;;       (mode . help-mode))
 ;;      ("emacs-lisp-mode"
 ;;       (mode . emacs-lisp-mode))
 ;;      ("w3m-mode"
 ;;       (mode . w3m-mode))
 ;;      ("haskell-mode"
 ;;       (mode . haskell-mode))
 ;;      ("Info-mode"
 ;;       (mode . Info-mode))
 ;;      ("Custom-mode"
 ;;       (mode . Custom-mode))
 ;;      ("dired-mode"
 ;;       (mode . dired-mode))
 ;;      ("org-mode"
 ;;       (mode . org-mode))
 ;;      ("fundamental-mode"
 ;;       (mode . fundamental-mode))
 ;;      ("vimrc-mode"
 ;;       (mode . vimrc-mode))
 ;;      ("custom-theme-choose-mode"
 ;;       (mode . custom-theme-choose-mode))
 ;;      ("haskell-interactive-mode"
 ;;       (mode . haskell-interactive-mode))
 ;;      ("lua-mode"
 ;;       (mode . lua-mode))
 ;;      ("grep-mode"
 ;;       (mode . grep-mode))
 ;;      ("haskell-cabal-mode"
 ;;       (mode . haskell-cabal-mode))
 ;;      ("messages-buffer-mode"
 ;;       (mode . messages-buffer-mode))
 ;;      ("c-mode"
 ;;       (mode . c-mode))
 ;;      ("shell-mode"
 ;;       (mode . shell-mode))
 ;;      ("compilation-mode"
 ;;       (mode . compilation-mode))
 ;;      ("magit-process-mode"
 ;;       (mode . magit-process-mode))
 ;;      ("sh-mode"
 ;;       (mode . sh-mode))
 ;;      ("nxml-mode"
 ;;       (mode . nxml-mode))
 ;;      ("js-mode"
 ;;       (mode . js-mode))
 ;;      ("python-mode"
 ;;       (mode . python-mode))
 ;;      ("conf-space-mode"
 ;;       (mode . conf-space-mode))
 ;;      ("magit-status-mode"
 ;;       (mode . magit-status-mode))
 ;;      ("magit-diff-mode"
 ;;       (mode . magit-diff-mode))
 ;;      ("completion-list-mode"
 ;;       (mode . completion-list-mode)))
 ;;     ("default"
 ;;      ("Org"
 ;;       (mode . org-mode))
 ;;      ("MyProject1"
 ;;       (filename . "src/myproject1/"))
 ;;      ("MyProject2"
 ;;       (filename . "src/myproject2/"))
 ;;      ("Programming"
 ;;       (or
 ;;        (mode . c-mode)
 ;;        (mode . perl-mode)
 ;;        (mode . python-mode)
 ;;        (mode . emacs-lisp-mode)))))))

;; (add-hook 'ibuffer-mode-hook
;;   (lambda ()
;;     (ibuffer-switch-to-saved-filter-groups "default")))

(global-set-key (kbd "C-x O") (lambda ()
                                (interactive)
                                (other-window -1)))

(use-package bookmark+
  :ensure t)
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
  :demand t
  :config
  (exec-path-from-shell-initialize))

(setq dired-auto-revert-buffer t)
(setq dired-omit-files "^\\.?#\\|^\\.DS_Store\\|^\\.$")
(use-package dired-x
  :demand t
  :config
  (add-hook 'dired-mode-hook 'dired-hide-details-mode)
  (add-hook 'dired-mode-hook 'dired-omit-mode))
(setq dired-dwim-target t)

(global-set-key (kbd "C-c o") 'my-eww-open-file-at-point)
(defun my-eww-open-file-at-point ()
  (interactive)
  (eww-open-file (thing-at-point 'filename)))

;; (load-theme 'badger t)

;; (use-package nlinum
;;   :ensure t
;;   :config (add-hook 'prog-mode-hook 'nlinum-mode))

(use-package yasnippet
  :ensure t
  :config (yas-global-mode nil))

(use-package gdb-mi
  :config
  (setq gdb-show-main t
        gdb-many-windows t)) 

(defun my-osx-term ()
  (interactive)
  ;; (async-shell-command "open -a Terminal.app .")
  (start-process "Terminal.app" "*Terminal.app*" "open" "-a" "Terminal.app" "."))
(global-set-key (kbd "C-c t") 'my-osx-term)


(global-set-key (kbd "C-c t") 'my-osx-term)

(global-set-key (kbd "C-c y") 'load-theme)
(global-set-key (kbd "C-c Y") 'customize-themes)

(use-package evil
  :ensure t
  :config (define-key evil-normal-state-map ";" 'evil-ex)
  :bind (("C-c w H" . evil-window-move-far-left)
         ("C-c w J" . evil-window-move-very-bottom)
         ("C-c w K" . evil-window-move-very-top)
         ("C-c w L" . evil-window-move-far-right)
         ("C-c v" . my-toggle-evil-mode-and-evil-escape)))

(defun my-toggle-evil-mode-and-evil-escape ()
  (interactive)
  (if evil-mode
      (progn
        (evil-mode 0)
        (evil-escape-mode 0))
    (evil-mode)
    (evil-escape-mode)))

(use-package evil-escape
  :ensure t
  :config
  (setq-default evil-escape-key-sequence "jk"))

(use-package todotxt
  :ensure t
  :config
  (setq todotxt-file todotxt-file) ; don't forget :)
  (setq todotxt-use-creation-dates nil)
  :bind ("C-x t" . todotxt))

(use-package tex :ensure auctex)
(setq TeX-PDF-mode t)
(setq TeX-save-query nil)

(setq TeX-view-program-selection
      '((output-pdf
         ;; "open"
         ;; "My Skim"
         "My PDF Tools"
         )))

(setq TeX-view-program-list
      '(("My Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")
        ("My PDF Tools" TeX-pdf-tools-sync-view)))

;; (add-to-list 'TeX-command-list
;;              '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))

;; (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\n\r")
;; (custom-set-variables `(org-emphasis-alist ',org-emphasis-alist))
;; (org-element--set-regexps)

;; (use-package eyebrowse
;;   :ensure t
;;   :config
;;   (eyebrowse-mode t)
;;   (eyebrowse-setup-opinionated-keys))

(use-package weechat
  :ensure t
  :config
  (setq weechat-host-default weechat-host-default
        weechat-mode-default 'ssl
        weechat-port-default 9001)
  (setq weechat-time-format "%H:%M"
        weechat-fill-column 80)
  ;; (add-hook 'weechat-relay-connect-hook 'visual-line-mode)
  (add-hook 'weechat-mode-hook 'visual-line-mode)
  (add-hook 'weechat-mode-hook 'my-set-input-method-TeX))

;; (defun my-weechat-connect ()
;;   (interactive)
;;   (weechat-connect weechat-host-default 9001 nil 'ssl))

(defun my-set-input-method-TeX ()
  (interactive)
  (set-input-method 'TeX))

(bind-keys ("M-<down>"  . enlarge-window)
           ("M-<up>"    . shrink-window)
           ("M-<left>"  . shrink-window-horizontally-4)
           ("M-<right>" . enlarge-window-horizontally-4))

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

;; (with-eval-after-load "org"
;;   (setcar (nthcdr 2 org-emphasis-regexp-components)
;;           " \t\r\n,'"
;;           ;; " \t\r\n,\"'"
;;           ))
;; (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\r\n,\"'")

(setq org-adapt-indentation nil)

(setq org-cycle-separator-lines 0)
(setq org-blank-before-new-entry
      '((heading . nil)
	(plain-list-item . nil)))
(setq org-return-follows-link t)


(setq calendar-latitude 47.6)
(setq calendar-longitude -122.3)
(setq calendar-location-name "Seattle, WA")

(setq org-edit-src-persistent-message nil)

(setq org-entities-user '(("vdots" "\\vdots" nil "&#8230" "|" "⋮" "⋮")))

(setq org-agenda-skip-deadline-prewarning-if-scheduled t)
(setq org-agenda-skip-scheduled-if-deadline-is-shown t)
;; (setq org-agenda-skip-scheduled-delay-if-deadline t)

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

(setq org-todo-keywords
      `(,(cons 'sequence (split-string "TODO WAITING | CANX DONE"))))

(setq c `((cons 'sequence '(a b))))

(setq notmuch-search-oldest-first nil)

;; (add-hook 'org-shiftup-final-hook 'windmove-up)
;; (add-hook 'org-shiftleft-final-hook 'windmove-left)
;; (add-hook 'org-shiftdown-final-hook 'windmove-down)
;; (add-hook 'org-shiftright-final-hook 'windmove-right)
;; (setq org-support-shift-select t)
;; (setq org-tags-column -70)

;; org-refile

;; (setq org-refile-use-outline-path 'full-file-path)
(setq org-refile-use-outline-path 'file)
(setq org-reverse-note-order t)
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-refile-targets `((,org-agenda-files :maxlevel . 1)))
;; (setq org-refile-allow-creating-parent-nodes t)
;; (setq org-refile-targets
;;       '((("~/my-org/omega.org"
;;           "~/Dropbox/Orgzly/orgzly.org"
;;           "~/Dropbox/Orgzly/doctor.org") :maxlevel . 2)))
;; (setq org-refile-targets
;;       `((,(file-expand-wildcards "~/my-org/*.org") :maxlevel . 1)
;;         (,(file-expand-wildcards "~/Dropbox/Orgzly/*.org") :maxlevel . 1)))
;; (setq org-completion-use-ido nil)


(setq org-agenda-todo-ignore-scheduled t)
(setq org-agenda-todo-ignore-deadlines t)

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
