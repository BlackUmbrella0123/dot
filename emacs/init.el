;;; init.el --- -*- lexical-binding: t no-byte-compile: t -*-

;;; Commentary:

;;;; Reference:
;;;; https://github.com/seagle0128/.emacs.d/tree/master
;;;; https://github.com/redguardtoo/emacs.d/tree/master
;;;; https://github.com/MiniApollo/kickstart.emacs
;;;; https://github.com/doomemacs/core
;;;; https://github.com/purcell/emacs.d
;;;; https://github.com/bbatsov/emacs.d
;;;; https://github.com/SystemCrafters/crafted-emacs
;;;; https://github.com/manateelazycat/lazycat-emacs
;;;; https://github.com/syl20bnr/spacemacs
;;;; https://github.com/jcs-emacs/jcs-emacs

;;; Code:

(when (eq system-type 'darwin)
  (setenv "MACOSX_DEPLOYMENT_TARGET" "27.0"))

(use-package use-package
  :ensure nil
  :custom
  (use-package-always-ensure t)
  (use-package-always-defer t)
  (use-package-expand-minimally t)
	(use-package-compute-statistics t)
  (use-package-enable-imenu-support t))

(use-package package
  :ensure nil
  :custom
  (package-enable-at-startup nil)
  :config
  (setq package-archives
        '(("melpa" . "https://melpa.org/packages/")
          ("gnu" . "https://elpa.gnu.org/packages/")
          ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
  (setq package-quictstart t)
  (package-initialize))

(use-package emacs
  :ensure nil
  :config
  (setq-default truncate-lines t)
  (setq-default tab-width 2)
  (setq-default create-lockfiles nil))

(use-package cus-edit
  :ensure nil
  :custom
  (custom-file (concat user-emacs-directory "custom.el")))

(use-package simple
  :ensure nil
  :hook
  (after-init . indent-tabs-mode)
  (prog-mode . line-number-mode)
  (prog-mode . column-number-mode)
  (prog-mode . size-indication-mode))

(use-package indent
  :ensure nil
  :config
  (setq standard-indent 2))

(use-package hl-line
  :ensure nil
  :hook
  (prog-mode . hl-line-mode))

(use-package display-line-numbers
  :ensure nil
  :hook
  (prog-mode . display-line-numbers-mode))

(use-package elec-pair
  :ensure nil
  :hook
  (prog-mode . electric-pair-mode))

(use-package paren
  :ensure nil
  :hook
  (prog-mode . show-paren-mode))

(use-package files
  :ensure nil
  :custom
  (make-backup-files nil)
  (auto-save-default nil))

(use-package recentf
  :ensure nil
  :hook
  (after-init . recentf-mode))

(use-package startup
  :ensure nil
  :custom
  (auto-save-list-file-prefix nil))

(use-package ibuffer
  :ensure nil
  :bind
  (("C-x C-b" . ibuffer)))

(use-package treesit
  :ensure nil
  :if (>= emacs-major-version 31)
  :config
  (setq treesit-enabled-modes t)
  (setq treesit-font-lock-level 4)
  (setq treesit-auto-install-grammar 'always)
  (setq treesit-enabled-modes t))

(use-package autorevert
  :ensure nil
  :hook
  (after-init . global-auto-revert-mode))

(use-package loaddefs
	:ensure nil
	:hook
	(after-init . save-place-mode))

(use-package which-key
  :hook
  (after-init . which-key-mode)
  :config
  (setq which-key-idle-delay 0.5))

(use-package dashboard
  :hook
  (after-init . dashboard-setup-startup-hook)
  :config
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  (setq dashboard-show-shortcuts t)
  (setq dashboard-navigation-cycle t)
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-icon-file-height 1.5)
  (setq dashboard-icon-file-v-adjust -0.15)
  (setq dashboard-heading-icon-height 1.5)
  (setq dashboard-heading-icon-v-adjust -0.15)
  (setq dashboard-heading-shorcut-format " [%s]")
  (setq dashboard-item-shortcuts '((recents   . "r")
                                   (bookmarks . "m")
                                   (projects  . "p")
                                   (agenda    . "a")
                                   (registers . "e")))
  (setq dashboard-items '((recents . 10)
                          (bookmarks . 5)
                          (projects . 5)
                          (agenda . 3)
                          (registers . 3))))

(use-package batppuccin
  :init
  (setq batppuccin-italic-comments t)
  (setq batppuccin-flat-mode-line t)
  (setq batppuccin-override-colors-alist
        '(("bat-base" . "#11111b")
          ("bat-mantle" . "#11111b")))
  :hook
  (after-init . (lambda ()
                  (load-theme 'batppuccin-mocha t)
                  (set-face-attribute 'line-number-current-line nil :foreground "#a6e3a1" :background 'unspecified :weight 'bold))))

(use-package doom-modeline
  :hook
  (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-height 25)
  (setq doom-modeline-bar-width 5)
  (setq doom-modeline-minor-modes t))

(use-package hide-mode-line
  :hook
  (completion-list-mode . hide-mode-line-mode)
  (dired-sidebar-mode . hide-mode-line-mode)
  (eshell-mode . hide-mode-line-mode)
  (term-mode . hide-mode-line-mode))

(use-package beacon
  :hook
  (after-init . beacon-mode)
  :config
  (setq beacon-size 50)
  (setq beacon-color (face-foreground 'error nil 'default))
  (setq beacon-blink-duration 0.5)
  (setq beacon-blink-delay 0.5)
  (setq beacon-blink-when-point-moves-vertically 20)
  (setq beacon-blink-when-point-moves-horizontally 20)
  (setq beacon-blink-when-focused t))

(use-package solaire-mode
  :defer 5
  :config
  (solaire-global-mode))

(use-package highlight-numbers
  :hook
  (prog-mode . highlight-numbers-mode))

(use-package highlight-defined
  :hook
  (emacs-lisp-mode . highlight-defined-mode))

(use-package auto-highlight-symbol
  :hook
  (prog-mode . global-auto-highlight-symbol-mode))

(use-package centaur-tabs
  :bind
  (:map evil-normal-state-map
        ("g t" . centaur-tabs-forward)
        ("g T" . centaur-tabs-backward))
  :init
  (setq centaur-tabs-style "bar")
  (setq centaur-tabs-height 25)
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-icon-type 'nerd-icons)
  (setq centaur-tabs-set-bar 'over)
  :hook
  (after-init . centaur-tabs-mode))

(use-package minions
  :hook
  (doom-modeline-mode . minions-mode))

(use-package breadcrumb
  :hook
  (prog-mode . breadcrumb-local-mode))

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :hook
  (after-init . evil-mode))

(use-package evil-escape
  :hook
  (evil-mode . evil-escape-mode)
  :config
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.2))

(use-package evil-collection
  :hook
  (evil-mode . evil-collection-init))

(use-package evil-nerd-commenter
  :after evil
  :bind
  (:map evil-normal-state-map
        ("gcc" . evilnc-comment-or-uncomment-lines))
  (:map evil-visual-state-map
        ("gc" . evilnc-comment-or-uncomment-lines)))

(use-package evil-matchit
  :hook
  (evil-mode . global-evil-matchit-mode))

(use-package evil-visualstar
  :hook
  (evil-mode . global-evil-visualstar-mode))

(use-package evil-goggles
  :hook
  (evil-mode . evil-goggles-mode)
  :config
  (setq evil-goggles-pulse t)
  (setq evil-goggles-duration 1.000)
  (evil-goggles-use-diff-faces))

(use-package evil-leader
  :hook
  (evil-mode . global-evil-leader-mode)
  :config
  (setq evil-leader/leader "<SPC>")
  (evil-leader/set-key
    "<SPC>" 'execute-extended-command
    "ff" 'find-file
    "fb" 'counsel-ibuffer
    "fe" 'counsel-flycheck
    "fc" 'counsel-load-theme
    "fr" 'counsel-recentf
    "fw" 'counsel-rg
    "fs" 'swiper-isearch
    "tt" 'emacs-init-time
    "ts" 'dired-sidebar-toggle-sidebar
    "tf" 'minimap-mode
    "ts" 'scratch
    "tr" 'quickrun
    "to" 'olivetti-mode
    "gl" 'avy-goto-line
    "gw" 'avy-goto-word-0
    "gc" 'avy-goto-char-timer
    "ww" 'ace-window
    "wd" 'delete-other-windows
    "wD" 'delete-window
    "hv" 'helpful-variable
    "hx" 'helpful-command
    "hk" 'helpful-key
    "hf" 'helpful-callable
    "hd" 'helpful-at-point
    "1" 'winum-select-window-1
    "2" 'winum-select-window-2
    "3" 'winum-select-window-3
    "4" 'winum-select-window-4
    "5" 'winum-select-window-5
    "6" 'winum-select-window-6
    "7" 'winum-select-window-7
    "8" 'winum-select-window-8
    "9" 'winum-select-window-9
    "0" 'winum-select-window-0-or-10))

(use-package ivy
  :hook
  (after-init . ivy-mode)
  :config
  (setq ivy-height 17)
  (setq ivy-wrap t)
  (setq ivy-fixed-height-minibuffer t)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "[%d/%d] ")
  (setq ivy-dynamic-exhibit-delay-ms 200)
  (setq ivy-initial-inputs-alist nil)
  (setq counsel-rg-base-command
        "rg --no-heading --line-number --color never %s .")
  (setq ivy-re-builders-alist
        '((t . ivy--regex-ignore-order)))
  (setq ivy-more-chars-alist
        '((counsel-rg . 2)
          (counsel-projectile-rg . 2))))

(use-package ivy-rich
  :hook
  (ivy-mode . ivy-rich-mode))

(use-package nerd-icons-ivy-rich
  :hook
  (ivy-mode . nerd-icons-ivy-rich-mode))

(use-package amx
  :hook
  (ivy-mode . amx-mode))

(use-package wgrep
  :config
  (setq wgrep-auto-save-buffer t))

(use-package counsel
  :hook
  (ivy-mode . counsel-mode)
  :bind
  (("C-c r" . counsel-recentf)
   ("C-c w" . counsel-rg)
   ("C-c j" . counsel-dired-jump)
   ("C-c b" . counsel-ibuffer)))

(use-package swiper
  :bind
  (("C-s" . swiper-isearch)))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package helpful
  :bind
  (("C-h k" . helpful-key)
   ("C-h v" . helpful-variable)
   ("C-h x" . helpful-command)
   ("C-h f" . helpful-callable)
   ("C-h C-d" . helpful-at-point)))

(use-package magit
  :commands magit-status)

(use-package flycheck
  :hook
  (prog-mode . global-flycheck-mode)
  :bind
  (("M-n" . flycheck-next-error)
   ("M-p" . flycheck-previous-error)))

(use-package flycheck-pos-tip
  :hook
  (global-flycheck-mode . flycheck-pos-tip-mode))

(use-package diredfl
  :hook
  (dired-mode . diredfl-mode))

(use-package symbol-overlay
  :bind
  (("M-i" . symbol-overlay-put)
   ("M-S-n" . symbol-overlay-next)
   ("M-S-p" . symbol-overlay-prev)
   ("M-S-r" . symbol-overlay-remove-all))
  :config
  (setq symbol-overlay-idle-time 0.5))

(use-package diff-hl
  :hook
  (after-init . global-diff-hl-mode)
  (after-init . global-diff-hl-show-hunk-mouse-mode)
  (dired-mode . diff-hl-dired-mode)
  (magit-post-refresh . diff-hl-magit-post-refresh))

(use-package hl-todo
  :hook
  (prog-mode . global-hl-todo-mode)
  :config
  (setq hl-todo-highlight-punctuation ":")
  (setq hl-todo-text-modes nil)
  (setq hl-todo-keyword-faces
        '(("TODO" warning bold)
          ("FIXME" error bold)
          ("REVIEW" font-lock-keyword-face bold)
          ("HACK" font-lock-constant-face bold)
          ("DEPRECATED" font-lock-doc-face bold)
          ("BUG" error bold)
          ("XXX" font-lock-constant-face bold)
          ("NOTE" success bold))))

(use-package nerd-icons-ibuffer
  :hook
  (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package ace-window
  :bind
  (([remap other-window] . ace-window))
  :config
  (setq aw-background nil)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package winum
  :hook
  (after-init . winum-mode))

(use-package company
	:after nerd-icons
  :hook
  (prog-mode . company-mode)
  :custom-face
  (company-tooltip ((t (:inherit default))))
  :config
  (defun my/company-backend-with-yas (backend)
    (if (or (not (listp backend))
            (member 'company-yasnippet backend))
        (append (if (listp backend)
                    backend
                  (list backend))
                '(:with company-yasnippet))
      backend))
  (setq company-idle-delay 0.24)
  (setq company-tooltip-limit 12)
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t)
	(setq company-format-margin-function 'company-text-icons-margin)
	(setq company-backends
				(mapcar #'my/company-backend-with-yas company-backends)))

(use-package flx)
(use-package company-fuzzy
  :after (company flx)
  :init
  (setq company-fuzzy-sorting-backend 'flx)
  (setq company-fuzzy-prefix-on-top nil)
  (setq company-fuzzy-trigger-symbols '("." "->" "<" "\"" "'" "@" "::" ":"))
  (setq company-fuzzy-reset-selection t)
  :hook
  (company-mode . company-fuzzy-mode))

(use-package yasnippet
  :hook
  (prog-mode . yas-minor-mode))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package avy
  :bind
  (("M-g l" . avy-goto-line)
   ("M-g c" . avy-goto-char-timer)
   ("M-g w" . avy-goto-word-0)))

(use-package direnv
  :when (executable-find "direnv")
  :hook
  (prog-mode . direnv-mode))

(use-package uv-mode
  :hook
  (python-mode . uv-mode-auto-activate-hook))

(use-package lua-mode
  :config
  (setq lua-indent-level 2)
  (setq lua-indent-nested-block-content-align nil)
  (setq lua-indent-close-paren-align nil))

(use-package clutch
  :commands clutch-query-sqlite-file
  :config
  (setq clutch-connect-timeout-seconds 10)
  (setq clutch-read-idle-timeout-seconds 30)
  (setq clutch-query-timeout-seconds 20)
  (setq clutch-jdbc-rpc-timeout-seconds 15)
  (setq clutch-jdbc-validate-after-idle-seconds 300))

(use-package dotenv-mode)
(use-package toml-mode)
(use-package web-mode)
(use-package json-mode)
(use-package haskell-mode)
(use-package dotenv-mode)
(use-package yaml-mode)
(use-package php-mode)
(use-package emmet-mode)
(use-package scss-mode)
(use-package sass-mode)
(use-package mmm-mode)
(use-package groovy-mode)
(use-package cmake-mode)
(use-package slim-mode)
(use-package csv-mode)
(use-package go-mode)
(use-package nix-mode)
(use-package git-modes)
(use-package scala-mode)
(use-package vimrc-mode)
(use-package rust-mode)
(use-package typescript-mode)
(use-package markdown-mode)
(use-package elixir-mode)
(use-package csharp-mode)
(use-package rjsx-mode)
(use-package swift-mode)
(use-package ess)
(use-package powershell)
(use-package polymode)
(use-package erlang)

(when (not (eq system-type 'windows-nt))
  (use-package ghostel))

(when (not (eq system-type 'windows-nt))
  (use-package mason
    :config
    (mason-setup)))

(use-package dired-sidebar
  :bind
  (("<f1>" . dired-sidebar-toggle-sidebar))
  :config
  (setq dired-sidebar-theme 'nerd-icons)
  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-theme 'nerd-icons)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

(use-package olivetti
  :commands olivetti-mode
  :init
  (setq olivetti-body-width 0.7))

(use-package minimap
  :commands minimap-mode
  :config
  (setq minimap-update-delay 0.25)
  (setq minimap-width-fraction 0.10)
  (setq minimap-minimum-width 10)
  (setq minimap-window-location 'right))

(use-package quickrun
  :commands quickrun
  :config
  (setq quickrun-focus-p nil)
  (setq quickrun-truncate-lines nil))

(use-package scratch
  :commands scratch)

(use-package lsp-mode
  :commands lsp
  :config
  (setq lsp-idle-delay 0.5)
  (setq lsp-log-io nil)
  (setq lsp-completion-provider :none)
  (setq lsp-enable-file-watchers nil)
  (setq lsp-enable-folding nil)
  (setq lsp-enable-text-document-color nil)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-enable-file-watchers nil)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-modeline-diagnostics-enable nil)
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]node_modules\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.git\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\dist\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.venv\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]__pycache__\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]target\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]build\\'"))

(use-package lsp-ui
  :after lsp-mode
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-show-with-cursor nil)
  (setq lsp-ui-doc-show-with-mouse nil)
  (setq lsp-ui-doc-delay 0.5)
  (setq lsp-ui-doc-max-width 80)
  (setq lsp-ui-doc-max-height 20)
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-show-hover nil)
  (setq lsp-ui-sideline-show-code-actions nil)
  (setq lsp-ui-sideline-delay 0.5)
  (setq lsp-ui-peek-enable t))

(use-package dap-mode
  :after lsp-mode)

(use-package dape
  :commands dape)

(use-package apheleia
  :hook
  (prog-mode . apheleia-mode))

(when (memq window-system '(mac ns x pgtk))
  (use-package exec-path-from-shell
    :defer 5
    :config
    (exec-path-from-shell-initialize)))

(use-package ibuffer-vc
  :after ibuffer
  :hook
  (ibuffer . (lambda ()
               (ibuffer-vc-set-filter-groups-by-vc-root)
               (unless (eq ibuffer-sorting-mode 'alphabetic)
                 (ibuffer-do-sort-by-alphabetic)))))

(use-package ibuffer-projectile
  :after (ibuffer projectile ibuffer-vc)
  :hook
  (ibuffer . (lambda ()
               (ibuffer-projectile-set-filter-groups)
               (unless (eq ibuffer-sorting-mode 'alphabetic)
                 (ibuffer-do-sort-by-alphabetic))))
  :config
  (setq ibuffer-formats
        '((mark modified read-only " "
                (name 18 18 :left :elide) " "
                (size-h 9 -1 :right) " "
                (mode 16 16 :left :elide) " "
                (vc-status 12 12 :left) " "
                project-file-relative))))

(use-package projectile
  :hook
  (after-init . projectile-mode)
  :bind
  (("C-c p" . projectile-command-map))
  :config
  (setq projectile-completion-system 'default)
  (setq projectile-indexing-method 'alien)
  (setq projectile-enable-caching t)
  (setq projectile-sort-order 'recently-active)
  (setq projectile-globally-ignored-directories
        (append '(".git" "node_modules" "__pycache__" ".venv" "target" "dist" "build")
                projectile-globally-ignored-directories))
  (setq projectile-known-projects-file
        (expand-file-name "projectile-bookmarks.eld" user-emacs-directory))
  (when (executable-find "rg")
    (setq projectile-generic-command "rg --files --hidden --follow --color=never")))

(use-package persp-mode
  :hook
  (after-init . persp-mode)
  :config
  (setq persp-keymap-prefix (kbd "C-c p"))
  (setq persp-nil-name "main")
  (setq persp-auto-save-opt 1)
  (setq persp-auto-resume-time -1)
  (setq persp-set-last-persp-for-new-frames t))

(use-package persp-mode-projectile-bridge
  :after (persp-mode projectile)
  :hook
  (after-init . persp-mode-projectile-bridge-mode)
  (persp-mode-projectile-bridge-mode . (lambda ()
                                         (if persp-mode-projectile-bridge-mode
                                             (persp-mode-projectile-bridge-find-perspectives-for-all-buffers)
                                           (persp-mode-projectile-bridge-kill-perspectives))))
  :config
  (setq persp-mode-projectile-bridge-persp-name-prefix ""))

(use-package hydra)
(use-package pretty-hydra
  :after hydra
  :bind
  (("<f6>" . toggles-hydra/body))
  :config
  (pretty-hydra-define toggles-hydra
    (:title "Toggles" :color amaranth :quit-key ("q" "C-g"))
    ("Basic"
     (("n" display-line-numbers-mode "line number" :toggle t)
      ("e" electric-pair-mode "electric pair *" :toggle t)
      ("c" flyspell-mode "spell check" :toggle t)
      ("s" prettify-symbols-mode "pretty symbol" :toggle t)
      ("b" display-battery-mode "battery *" :toggle t)
      ("i" display-time-mode "time *" :toggle t)
      ("m" doom-modeline-mode "modern mode-line *" :toggle t))
     "Window Management"
     (("w o" other-window "switch")
      ("w d" ace-delete-window "delete")
      ("w m" ace-delete-other-windows "maximize")
      ("w s" ace-swap-window "swap")
      ("w a" ace-select-window "select")
      ("w b" balance-windows "balance")
      ("w f" toggle-frame-fullscreen "toggle fullscreen"))
     "Resize"
     (("+" text-scale-increase "text zoom in")
      ("-" text-scale-decrease "text zoom out")
      ("0" (text-scale-set 0) "text reset")
      ("}" enlarge-window-horizontally "window wider")
      ("{" shrink-window-horizontally "window narrower")
      ("^" enlarge-window "window taller")
      ("v" shrink-window "window shorter")
      ("=" balance-windows "window reset"))
     "Highlight"
     (("h l" global-hl-line-mode "line *" :toggle t)
      ("h p" show-paren-mode "parenthesis *" :toggle t)
      ("h s" symbol-overlay-mode "symbol" :toggle t)
      ("h r" global-colorful-mode "color *" :toggle t)
      ("h w" (setq-default show-trailing-whitespace (not show-trailing-whitespace))
       "whitespace" :toggle show-trailing-whitespace)
      ("h d" rainbow-delimiters-mode "delimiter" :toggle t)
      ("h i" indent-bars-mode "indent" :toggle t)
      ("h t" global-hl-todo-mode "todo *" :toggle t)))))

(when
    (and (eq system-type 'gnu/linux)
         (not (display-graphic-p))
         (or (executable-find "xclip")
             (executable-find "xsel")))
  (use-package xclip
    :hook
    (after-init . xclip-mode)))

(use-package gcmh
  :hook
  (after-init . gcmh-mode))

(use-package colorful-mode
  :hook
  (prog-mode . colorful-mode))

(when (not (eq system-type 'windows-nt))
  (use-package ai-code
    :bind
    (("C-c a" . ai-code-menu))
    :config
    (ai-code-set-backend 'claude-code)
    (setq ai-code-backends-infra-terminal-backend 'ghostel)))

(provide 'init)
;;; init.el ends here
