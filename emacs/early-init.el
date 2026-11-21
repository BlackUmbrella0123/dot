;;; early-init.el --- Early initialization. -*- lexical-binding: t no-byte-compile: t -*-
;;; Commentary:
;;; Code:

(prefer-coding-system 'utf-8)
(setq custom-file (expand-file-name "custom.el" (file-name-as-directory user-emacs-directory)))
(setq gc-cons-percentage 1.0)
(setq gc-cons-threshold most-positive-fixnum)
(setq read-process-output-max #x10000)
(setq native-comp-deferred-compilation nil)
(setq native-comp-jit-compilation nil)
(setq package-quickstart t)
(setq package-enable-at-startup nil)
(setq load-prefer-newer noninteractive)
(setq use-package-enable-imenu-support t)
(setq frame-inhibit-implied-resize t)
(setq inhibit-startup-message t)
(setq initial-major-mode 'fundamental-mode)
(setq default-frame-alist
      '((menu-bar-lines . 0)
        (tool-bar-lines . 0)
        (internal-border-width . 12)
        (horizontal-scroll-bars)
        (vertical-scroll-bars)))
(when (featurep 'ns)
  (push '(ns-appearance . dark) default-frame-alist))

(let ((default-file-name-handler-alist file-name-handler-alist)
      (default-load-suffixes load-suffixes)
      (default-load-file-rep-suffixes load-file-rep-suffixes))
  (setq file-name-handler-alist nil
        load-suffixes '(".elc" ".el")
        load-file-rep-suffixes '(""))
  (add-hook 'emacs-startup-hook
            (lambda ()
              (setq load-suffixes default-load-suffixes
                    load-file-rep-suffixes default-load-file-rep-suffixes
                    file-name-handler-alist default-file-name-handler-alist))
            101))

(defun my/setup-fonts ()
  "Setup fonts."
  (require 'cl-lib)
  (when (display-graphic-p)
    ;; Set default font
    (cl-loop for font in '("Jetbrains Mono"
                           "JetBrainsMono Nerd Font"
                           "SF Mono"
                           "Menlo"
                           "Hack"
                           "Source Code Pro"
                           "Monaco"
                           "Consolas")
             when (find-font (font-spec :name font))
             return (set-face-attribute 'default nil
                                        :family font
                                        :height (cond ((eq system-type 'darwin) 130)
                                                      ((eq system-type 'windows-nt) 110)
                                                      (t 100))))

    ;; Set mode-line font
    (cl-loop for font in '("Jetbrains Mono"
                           "JetBrainsMono Nerd Font"
                           "Arial"
                           "Helvetica"
                           "Times New Roman")
             when (find-font (font-spec :name font))
             return (progn
                      (set-face-attribute 'mode-line nil :family font :inherit 'variable-pitch)
                      (set-face-attribute 'mode-line-inactive nil :family font :inherit 'variable-pitch)))

    ;; Specify font for all unicode characters
    (cl-loop for font in '("Apple Symbols"
                           "Segoe UI Symbol"
                           "Symbola"
                           "Symbol")
             when (find-font (font-spec :name font))
             return (set-fontset-font t 'symbol (font-spec :family font) nil 'prepend))

    ;; Specify font for Emoji characters
    (cl-loop for font in '("Noto Color Emoji"
                           "Apple Color Emoji"
                           "Segoe UI Emoji")
             when (find-font (font-spec :name font))
             return (set-fontset-font t 'emoji (font-spec :family font) nil 'prepend))

    ;; Specify font for Chinese characters
    (cl-loop for font in '("LXGW Neo Xihei"
                           "LXGW WenKai Mono"
                           "WenQuanYi Micro Hei Mono"
                           "PingFang SC"
                           "Microsoft Yahei UI"
                           "Simhei")
             when (find-font (font-spec :name font))
             return (progn
                      (setq face-font-rescale-alist `((,font . 1.3)))
                      (set-fontset-font t 'han (font-spec :family font))))))
(add-hook 'window-setup-hook #'my/setup-fonts)
(add-hook 'server-after-make-frame-hook #'my/setup-fonts)

(provide 'early-init)
;;; early-init.el ends here
