;;; package --- Summary
;;; Commentary:
;;
;; IMPORTANT: This config requires ~/.emacs.d/early-init.el with:
;;   (setq package-enable-at-startup nil)
;; This prevents package.el from conflicting with straight.el
;;

;;; Code:

;;; ==========================================================================
;;; Frame settings
;;; ==========================================================================
(add-to-list 'default-frame-alist '(height . 61))
(add-to-list 'default-frame-alist '(width . 123))
(pcase system-type
  ('windows-nt
   (add-to-list 'default-frame-alist '(top . 0))
   (add-to-list 'default-frame-alist '(left . 1270)))
  ('gnu/linux
   (add-to-list 'default-frame-alist '(top . 522))
   (add-to-list 'default-frame-alist '(left . 2720))))

;;; ==========================================================================
;;; straight.el - package manager
;;; ==========================================================================
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

;; Use built-in packages for Emacs 29+ (avoid conflicts)
(dolist (pkg '(project eglot flymake xref eldoc))
  (add-to-list 'straight-built-in-pseudo-packages pkg))

;;; ==========================================================================
;;; Core packages (load early - other packages depend on these)
;;; ==========================================================================

;;; compat - compatibility library (must load first)
(use-package compat
  :demand t)


;;; company (needed for some backends like hy)
(use-package company
  :demand t)

;;; cape - completion at point extensions
(use-package cape
  :demand t
  :config
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions (cape-company-to-capf #'company-dabbrev-code))
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  ;; Make cape-capf-super the primary CAPF globally
  (add-hook 'completion-at-point-functions
            (cape-capf-super
             (cape-company-to-capf #'company-dabbrev-code)
             #'cape-file
             #'cape-keyword)))

;;; corfu - modern completion UI (replaces company)
(use-package corfu
  :demand t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-preselect 'first)
  (corfu-count 10)              ; Show more candidates
  (corfu-quit-at-boundary nil)  ; Don't quit at pattern boundary
  (corfu-quit-no-match t)       ; Quit if no match
  :bind
  (:map corfu-map
        ("TAB" . corfu-insert)
        ([tab] . corfu-insert)
        ("RET" . corfu-insert))
  :config
  (global-corfu-mode)
  (corfu-popupinfo-mode))

;;; corfu-terminal - corfu support for terminal emacs
(use-package corfu-terminal
  :straight (corfu-terminal :type git :repo "https://codeberg.org/akib/emacs-corfu-terminal.git")
  :after corfu
  :config
  (unless (display-graphic-p)
    (corfu-terminal-mode 1)))

;;; vertico - vertical completion UI (replaces helm)
(use-package vertico
  :demand t
  :config (vertico-mode))

;;; orderless - flexible matching (space-separated patterns)
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-ignore-case t))

;;; marginalia - annotations in minibuffer
(use-package marginalia
  :init (marginalia-mode))

;;; consult - enhanced search commands
(use-package consult
  :bind
  (("C-s" . consult-line)
   ("C-x b" . consult-buffer)
   ("M-g g" . consult-goto-line)
   ("M-s r" . consult-ripgrep)
   ("M-s f" . consult-find)))

;;; embark - contextual actions
(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)))

;;; embark-consult integration
(use-package embark-consult
  :after (embark consult))

;;; ==========================================================================
;;; Basic settings
;;; ==========================================================================
(xterm-mouse-mode t)
(global-set-key [mouse-4] 'scroll-down-line)
(global-set-key [mouse-5] 'scroll-up-line)

;;; I prefer cmd key for meta (macOS)
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

;;; ==========================================================================
;;; Theme
;;; ==========================================================================
(use-package vscode-dark-plus-theme
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

;;; ==========================================================================
;;; Python development
;;; ==========================================================================

;; conda environment management
(use-package conda
  :init
  (setq conda-anaconda-home (expand-file-name "~/miniconda3"))
  (setq conda-env-home-directory (expand-file-name "~/miniconda3"))
  ;; (setq conda-anaconda-home (expand-file-name "c:/ProgramData/Miniconda3"))
  (conda-env-activate "base"))

;;; envrc - direnv integration for per-project environments
(use-package envrc
  :hook (after-init . envrc-global-mode))

;;; eglot with basedpyright (use built-in eglot)
(use-package eglot
  :straight nil  ; use built-in, don't install via straight
  :init
  (defalias 'start-lsp-server #'eglot)
  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("basedpyright-langserver" "--stdio")))
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              ;; Merge eglot with cape-dabbrev and others
              (setq-local completion-at-point-functions
                          (list (cape-capf-super
                                 #'eglot-completion-at-point
                                 (cape-company-to-capf #'company-dabbrev-code)
                                 #'cape-file)))))
  :hook
  ((python-mode python-ts-mode clojure-mode js-mode) . eglot-ensure))

;;; flymake-ruff for Python linting (eglot uses flymake)
(use-package flymake-ruff
  :hook (python-mode . flymake-ruff-load))

;;; apheleia - async formatting on save (ruff replaces isort + black)
(use-package apheleia
  :config
  (setf (alist-get 'ruff-isort apheleia-formatters)
        '("ruff" "check" "--select" "I" "--fix" "--stdin-filename" filepath "-"))
  (setf (alist-get 'ruff-format apheleia-formatters)
        '("ruff" "format" "--stdin-filename" filepath "-"))
  (setf (alist-get 'python-mode apheleia-mode-alist)
        '(ruff-isort ruff-format))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff-isort ruff-format))
  (apheleia-global-mode t))

;;; ==========================================================================
;;; Clojure development
;;; ==========================================================================
(use-package clojure-mode
  :config
  (add-hook 'clojure-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions
                          (list (cape-capf-super
                                 (cape-company-to-capf #'company-dabbrev-code)
                                 #'cape-keyword
                                 #'cape-file))))))
(use-package cider)

;;; ==========================================================================
;;; JavaScript
;;; ==========================================================================
(add-hook 'js-mode-hook
          (lambda ()
            (setq js-indent-level 2)))

;;; ==========================================================================
;;; Lisp / Scheme / Racket
;;; ==========================================================================
(use-package paredit
  :config
  (mapc (lambda (mode)
          (let ((hook (intern (concat (symbol-name mode)
                                      "-mode-hook"))))
            (add-hook hook (lambda () (paredit-mode 1)))
            (add-hook hook (lambda () (electric-pair-mode 1)))))
        '(emacs-lisp inferior-lisp slime lisp-interaction scheme racket clojure hy inferior-hy)))

(use-package racket-mode)

;; hy-mode (lispy)
(use-package hy-mode
  :straight (hy-mode :type git :host github :repo "jetack/lpy-mode")
  :config
  (add-hook 'hy-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions
                          (list (cape-capf-super
                                 (cape-company-to-capf #'company-hy)
                                 (cape-company-to-capf #'company-dabbrev-code)
                                 #'cape-keyword
                                 #'cape-file)))))
  (add-hook 'inferior-hy-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions
                          (list (cape-company-to-capf #'company-dabbrev-code) #'cape-file)))))

(add-to-list 'auto-mode-alist '("\\.lpy\\|.sy\\'" . hy-mode))

;;; ==========================================================================
;;; File browser
;;; ==========================================================================
(use-package treemacs
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
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         30
          treemacs-workspace-switch-cleanup      nil)
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

;;; ==========================================================================
;;; Other packages
;;; ==========================================================================
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package multiple-cursors
  :config
  (global-set-key (kbd "M-n") 'mc/mark-next-like-this)
  (global-set-key (kbd "M-p") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-M-L") 'mc/mark-all-like-this))

;;; ==========================================================================
;;; UI settings
;;; ==========================================================================
(add-hook 'prog-mode-hook 'electric-pair-mode)
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq inhibit-startup-screen t)
(setq initial-major-mode 'hy-mode)
(setq initial-scratch-message "")
(display-time)
(transient-mark-mode t)
(global-display-line-numbers-mode t)
(setq column-number-mode t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(defvaralias 'c-basic-offset 'tab-width)

;;; ==========================================================================
;;; Shortcuts
;;; ==========================================================================
(global-set-key [C-kanji] 'set-mark-command) ;; for windows

(global-set-key [f5] 'compile)
(global-set-key [f6] 'gdb)
(global-set-key [f3] 'python-indent-shift-left)
(global-set-key [f4] 'python-indent-shift-right)
(global-set-key [f7] 'previous-buffer)
(global-set-key [f8] 'next-buffer)
(global-set-key [f12] 'shell)

;;; ==========================================================================
;;; Fonts and locale
;;; ==========================================================================
(custom-set-faces
 '(default ((t (:family "MesloLGS Nerd Font Mono" :foundry "unknown" :slant normal :weight normal :height 139 :width normal)))))

(set-language-environment "Korean")
(prefer-coding-system 'utf-8)

(set-face-attribute 'default nil :font "MesloLGS NF-13")
(set-fontset-font t 'hangul (font-spec :name "D2Coding-15"))
(set-fontset-font t 'unicode (font-spec :name "D2Coding-15") nil 'append)

;;; .emacs ends here
