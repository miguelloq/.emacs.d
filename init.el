;;; -*- lexical-binding: t -*-

;; Repositório MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; Instalar use-package se não existir
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; =====================================
;; VISUAL
;; =====================================

(if (eq system-type 'windows-nt)
    (add-to-list 'default-frame-alist '(fullscreen . maximized)) ;;caso esteja no Windows → abre em tela cheia
  (setq default-frame-alist ;;caso contrário Linux/macOS
        '((width . 153) (height . 110) (left . 0) (top . 0))))

(set-face-attribute 'default nil :height 150) ;; Tamanho fonte(?)
(add-hook 'dired-mode-hook #'dired-hide-details-mode) ;; Remove um monte de informacoes no dired buffer
(setq initial-scratch-message "") ;; Remove mensagem inicial do scratch
(tool-bar-mode -1) ;; Desativa tool-bar
(menu-bar-mode -1) ;; Desativa menu que fica em cima da janela
(global-display-line-numbers-mode) ;; Ativa numeros nas linhas
(when (fboundp 'scroll-bar-mode)(scroll-bar-mode -1)) ;;Desativa scroll bar

(use-package catppuccin-theme
  :config
  (setq catppuccin-flavor 'frappe)
  (load-theme 'catppuccin :no-confirm)
  (catppuccin-reload))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-banner-logo-title "Welcome home, Miguel.")
  (setq dashboard-startup-banner "~/.emacs.d/avatar.gif")
  (setq dashboard-center-content t)
  (setq dashboard-items '((recents . 10) (projects . 5)))
  (setq dashboard-footer-messages '("I ❤️ FP"))
  )

;; =====================================
;; CONFIGURAÇÕES GERAIS
;; =====================================

;; Ativa salvamento automático do buffer real
(auto-save-visited-mode 1)
(setq auto-save-visited-interval 2)

(setq mac-command-modifier 'meta mac-option-modifier 'none) ;; No MacOs, meta virá CMD e não mais Option

(use-package recentf
  :config
  (recentf-mode 1)
  (setq recentf-max-saved-items 50)
)

(use-package paredit ;; fecha parenteses, chaves, aspas etc
  :hook ((emacs-lisp-mode . enable-paredit-mode)
         (clojure-mode . enable-paredit-mode)
         (cider-repl-mode . enable-paredit-mode)))

;;(add-hook 'kotlin-mode-hook #'electric-pair-local-mode) ;; Kotlin fecha aspas/chaves automático

;; =====================================
;; COMPLETION
;; =====================================

(use-package vertico ;;interface leve de completude no minibuffer (M-x, C-x C-f, etc)
  :init
  (vertico-mode)
  (setq vertico-cycle t))

(use-package marginalia ;;mostra informações extras ao lado das opções (ex: keybindings no M-x)
  :init
  (marginalia-mode))

(use-package orderless ;;deixa a busca mais esperta: você pode digitar pedaços soltos
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package company 
  :init
  (global-company-mode)
  :custom
  (company-idle-delay 0)
  (company-echo-delay 0)
  (company-minimum-prefix-length 1))

;;(use-package yasnippet ;;ao escolher uma funcao auto-complete faz com que substituir os parametros sejam mais faceis, usei no kotlin
;;  :config
;;  (yas-global-mode 1))

;; =====================================
;; LSP / IDE Features
;; =====================================

;;(use-package kotlin-mode
;;  :after (lsp-mode dap-mode)
;;  :hook (kotlin-mode . lsp-deferred)
;;  :config
;;  (require 'dap-kotlin)
;;  (setq lsp-kotlin-debug-adapter-path (or (executable-find "kotlin-debug-adapter") "")))

(use-package lsp-mode
  :bind ("M-RET" . lsp-execute-code-action))

(use-package lsp-ui
  :after lsp-mode
  :custom
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-doc-position 'at-point))

(use-package lsp-treemacs
  :after lsp-mode
  :config
  (lsp-treemacs-sync-mode 1))

;; Flycheck para mostrar os warnings/erros (ex: variáveis não usadas)
(use-package flycheck
  :hook (lsp-mode . flycheck-mode))

;; =====================================
;; CLOJURE
;; =====================================

(use-package cider)
(use-package clj-refactor)

;; =====================================
;; HASKELL
;; =====================================

(use-package haskell-mode)

;; =====================================
;; GIT / DIFF
;; =====================================

(use-package magit)
(use-package diff-hl ;;Highlight de alteracao,adicao de linhas no GIT
  :hook ((prog-mode . diff-hl-mode)
         (vc-dir-mode . diff-hl-dir-mode))
  :config
  (diff-hl-flydiff-mode)
  (diff-hl-margin-mode))

;; =====================================
;; TERMINAL
;; =====================================
(unless (eq system-type 'windows-nt)(use-package vterm))

;; =====================================
;; EMACS DOING DUMB STUFF
;; =====================================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
