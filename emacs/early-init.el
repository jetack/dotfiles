;;; early-init.el --- Early initialization -*- lexical-binding: t -*-
;;; Commentary:
;;
;; This file is loaded before init.el/.emacs
;; Used to disable package.el so straight.el can manage packages
;;

;;; Code:

;; Disable package.el in favor of straight.el
(setq package-enable-at-startup nil)

;; Prevent package.el from modifying this file
(setq package--init-file-ensured t)

;; Faster startup - restore after init
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)))) ;; 16MB

;;; early-init.el ends here
