;;; init.el --- My Emacs Configuration.	-*- lexical-binding: t no-byte-compile: t -*-
;;; Commentary:
;;; Code:

;; https://github.com/manateelazycat/lazycat-emacs
;; https://github.com/redguardtoo/emacs.d/tree/master
;; https://github.com/seagle0128/.emacs.d
;; https://github.com/doomemacs/core
;; https://github.com/bbatsov/prelude
;; https://github.com/purcell/emacs.d
;; https://github.com/SystemCrafters/crafted-emacs

;;; Core
(when (eq system-type 'darwin)
  (setenv "MACOSX_DEPLOYMENT_TARGET"
	        (string-trim
	         (shell-command-to-string
	          "sw_vers -productVersion"))))

(use-package use-package
  :ensure nil
  :init
  (setq use-package-always-ensure t)
  (setq use-package-always-defer t)
  (setq use-package-expand-minimally t)
  (setq use-package-enable-imenu-support t))

(use-package package
  :ensure nil
  :init
  (setq package-enable-at-startup nil)
  :config
  (package-initialize)
  (setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			                     ("nongnu" . "https://elpa.nongnu.org/nongnu/")
			                     ("melpa" . "https://melpa.org/packages/")))
  (setq package-quickstart t))

(use-package emacs
  :ensure nil
  :config
  (setq create-lockfiles nil)
  (setq-default tab-width 2)
  (setq-default truncate-lines t))

(use-package files
  :ensure nil
  :init
  (setq auto-save-default nil)
  (setq make-backup-files nil))

(use-package simple
  :ensure nil
  :config
  (setq-default indent-tabs-mode nil))

(use-package hl-line
  :ensure nil
  :hook (prog-mode . hl-line-mode))

(use-package elec-pair
  :ensure nil
  :hook (prog-mode . electric-pair-mode))

(use-package display-line-numbers
  :ensure nil
  :init
  (setq-default display-line-numbers-type 'relative)
  :hook (prog-mode . display-line-numbers-mode))

;;; Melpa
(use-package evil
  :hook (after-init . evil-mode))

(use-package evil-escape
  :hook (evil-mode . evil-escape-mode)
  :config
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.2))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package vertico
  :hook
  (after-init . vertico-mode)
  :config
  (setq vertico-scroll-margin 0)
  (setq vertico-count 16)
  (setq vertico-resize t)
  (setq vertico-cycle t))

(use-package orderless
  :after vertico
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package consult
  :after vertico
  :bind
  (("C-s" . consult-line)
   ("C-x b" . consult-buffer)
   ("C-x C-b" . consult-buffer)
   ("M-g o" . consult-outline)))

(use-package corfu
  :hook
  (after-init . global-corfu-mode)
  (global-corfu-mode . corfu-popupinfo-mode)
  (global-corfu-mode . corfu-history-mode)
  :config
  (setq corfu-cycle t)
  (setq corfu-auto t)
  (setq corfu-auto-delay 0.2)
  (setq corfu-count 12)
  (setq corfu-popupinfo-delay '(0.4 . 0.2))
  (setq global-corfu-modes '((not erc-mode
                                  circe-mode
                                  help-mode
                                  gud-mode)
                             t)))

(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

(provide 'init)
;;; init.el ends here
