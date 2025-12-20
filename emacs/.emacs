;;; package --- Summary
;;; Commentary:

;;; Code:
;;frame size
(add-to-list 'default-frame-alist '(height . 61))
(add-to-list 'default-frame-alist '(width . 123))
(pcase system-type
  ('windows-nt
   (add-to-list 'default-frame-alist '(top . 0))
   (add-to-list 'default-frame-alist '(left . 1270)))
  ('gnu/linux
   (add-to-list 'default-frame-alist '(top . 522))
   (add-to-list 'default-frame-alist '(left . 2720))))




;;; straight.el
(setq package-enable-at-startup nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)
(use-package straight
  :custom (straight-use-package-by-default t))

;;melpa settings
;; (require 'package) ;; You might already have this line
;; (add-to-list 'package-archives
;;              '("melpa" . "https://melpa.org/packages/"))
;; (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
;; (package-initialize) ;; You might already have this line

;; for use-package
;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))

;; (require 'use-package-ensure)
;; (setq use-package-always-ensure t) ;;when package install need


(xterm-mouse-mode t)
(global-set-key [mouse-4] 'scroll-down-line)
(global-set-key [mouse-5] 'scroll-up-line)

;;; I prefer cmd key for meta
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

(global-unset-key "\C-z")
(global-set-key "\C-z" 'advertised-undo)

;;; windmove
(use-package windmove
  :config
  (when (fboundp 'windmove-default-keybindings)
    (windmove-default-keybindings)))

;;themes
(use-package vscode-dark-plus-theme
  :ensure t
  :config
  (load-theme 'vscode-dark-plus t)
  (custom-set-faces
   '(rainbow-delimiters-depth-1-face ((t (:foreground "#887200"))))
   '(rainbow-delimiters-depth-2-face ((t (:foreground "#6e396c"))))
   '(rainbow-delimiters-depth-3-face ((t (:foreground "#3f6176"))))
   '(rainbow-delimiters-depth-4-face ((t (:foreground "#887200"))))
   '(rainbow-delimiters-depth-5-face ((t (:foreground "#6e396c"))))
   '(rainbow-delimiters-depth-6-face ((t (:foreground "#3f6176"))))
   '(rainbow-delimiters-depth-7-face ((t (:foreground "#887200"))))
   '(rainbow-delimiters-depth-8-face ((t (:foreground "#6e396c"))))
   '(rainbow-delimiters-depth-9-face ((t (:foreground "#3f6176"))))))
;; (use-package github-modern-theme
;;   :ensure t
;;   :config
;;   (load-theme 'github-modern t)
;;   (custom-set-faces
;;    '(rainbow-delimiters-depth-1-face ((t (:foreground "#c9a902"))))
;;    '(rainbow-delimiters-depth-2-face ((t (:foreground "#bf62bc"))))
;;    '(rainbow-delimiters-depth-3-face ((t (:foreground "#70b2db"))))
;;    '(rainbow-delimiters-depth-4-face ((t (:foreground "#c9a902"))))
;;    '(rainbow-delimiters-depth-5-face ((t (:foreground "#bf62bc"))))
;;    '(rainbow-delimiters-depth-6-face ((t (:foreground "#70b2db"))))
;;    '(rainbow-delimiters-depth-7-face ((t (:foreground "#c9a902"))))
;;    '(rainbow-delimiters-depth-8-face ((t (:foreground "#bf62bc"))))
;;    '(rainbow-delimiters-depth-9-face ((t (:foreground "#70b2db"))))))


;; ;; optional if you want which-key integration
;; (use-package which-key
;;   :config
;;   (which-key-mode))

;; clojure
(use-package clojure-mode
  :config
  (add-hook 'clojure-mode-hook
            (lambda ()
              (add-to-list 'company-backends 'company-dabbrev-code))))
(use-package cider)

(add-hook 'js-mode-hook
          (lambda ()
            (setq js-indent-level 2)))

;; python
(use-package conda
  :ensure t
  :init
  (setq conda-anaconda-home (expand-file-name "~/miniconda3"))
  (setq conda-env-home-directory (expand-file-name "~/miniconda3"))
  ;; (setq conda-anaconda-home (expand-file-name "c:/ProgramData/Miniconda3"))
  (conda-env-activate "base")
  )

;;; eglot
(use-package eglot
  :ensure t
  :init
  (defalias 'start-lsp-server #'eglot)
  (add-hook 'prog-mode-hook #'eglot-ensure))


;; treemacs
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-read-string-input             'from-child-frame
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          ;; treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         25
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

;;company
(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-minimum-prefix-length 2))

;;flycheck
(use-package flycheck
  :config
  (global-flycheck-mode))

;;helm
(use-package helm
  :config
  (helm-mode 1))


;;lisp settings
(use-package paredit
  :config
  (mapc (lambda (mode)
          (let ((hook (intern (concat (symbol-name mode)
                                      "-mode-hook"))))
            (add-hook hook (lambda () (paredit-mode 1)))
            (add-hook hook (lambda () (electric-pair-mode 1)))))
        '(emacs-lisp inferior-lisp slime lisp-interaction scheme racket clojure hy inferior-hy)))

;;racket
(use-package racket-mode)

;; lispy settings
(use-package hy-mode
  :straight (hy-mode :type git :host github :repo "jetack/lpy-mode")
  :config
  (add-hook 'hy-mode-hook
            (lambda ()
              (company-mode 1)
              (add-to-list 'company-backends '(company-hy company-dabbrev-code))))
  (add-hook 'inferior-hy-mode-hook
            (lambda ()
              (company-mode 1))))

(add-to-list 'auto-mode-alist '("\\.lpy\\|.sy\\'" . hy-mode))

;; rainbow-delimiters
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;;isort and black formatting
(use-package py-isort
  :init
  (add-hook 'before-save-hook 'py-isort-before-save))

(use-package python-black
  :demand t
  :after python
  :config
  (add-hook 'python-mode-hook (lambda () (python-black-on-save-mode 1))))


(use-package multiple-cursors
  :config
  (global-set-key (kbd "M-n") 'mc/mark-next-like-this)
  (global-set-key (kbd "M-p") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-M-L") 'mc/mark-all-like-this)
  )

;;UI settings
(add-hook 'prog-mode-hook 'electric-pair-mode) ;;parenthesis completion
(show-paren-mode 1) ;;show paren mode
(setq show-paren-delay 0)
(setq inhibit-startup-screen t) ;;skip startup screen and specify default mode
(setq initial-major-mode 'hy-mode)
(setq initial-scratch-message "")
(display-time) ;;show time on status bar
(transient-mark-mode t) ;; show selected area
(global-display-line-numbers-mode t) ;; show line numbers
(setq column-number-mode t) ;; show column number
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(defvaralias 'c-basic-offset 'tab-width)

;;shortcuts
(global-set-key [C-kanji] 'set-mark-command) ;; for windows

(global-set-key [f5] 'compile)
(global-set-key [f6] 'gdb)

(global-set-key [f3] 'python-indent-shift-left)
(global-set-key [f4] 'python-indent-shift-right)
(global-set-key [f7] 'previous-buffer)
(global-set-key [f8] 'next-buffer)

(global-set-key [f12] 'shell)

;;emacs windows
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "MesloLGS Nerd Font Mono" :foundry "unknown" :slant normal :weight normal :height 139 :width normal)))))

;;korean environment
(set-language-environment "Korean")
(prefer-coding-system 'utf-8)

;; (set-face-attribute 'default nil :font "Ubuntu Mono derivative Powerline-15")
(set-face-attribute 'default nil :font "MesloLGS NF-13")
(set-fontset-font t 'hangul (font-spec :name "D2Coding-15"))
(set-fontset-font t 'unicode (font-spec :name "D2Coding-15") nil 'append)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company-jedi paren-face dash cider clojure-mode spinner vscode-dark-plus-theme conda multiple-cursors python-black py-isort rainbow-delimiters hy-mode racket-mode paredit helm company color-theme-sanityinc-tomorrow use-package)))
