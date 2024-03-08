;; -*- lexical-binding: t -*-

(defun flo/insert-date (&optional with-time)
  (interactive "P")
  (insert (format-time-string
           (concat "%Y-%m-%d" (when with-time "T%H:%M:%S")))))

(use-package package
  :custom
  ;; '(("gnu"    . "https://elpa.gnu.org/packages/")
  ;;   ("nongnu" . "https://elpa.gnu.org/packages/"))
  (package-archives '(("melpa"        . "https://melpa.org/packages/")
                      ("melpa-stable" . "https://stable.melpa.org/packages/")
                      ("nongnu"       . "https://elpa.gnu.org/packages/")
                      ("gnu"          . "https://elpa.gnu.org/packages/")))
  :init
  (package-initialize)
  (unless package-archive-contents
    (package-refresh-contents)))

(defvar bootstrap-version)
(defvar straight-repository-branch "develop")
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

(use-package blackout
  :straight t)

(use-package battery
  :unless (string-search "N/A%" (let ((inhibit-message t)) (battery)))
  :config
  (display-battery-mode))

(use-package buffer
  :no-require t
  :custom
  ; 8
  (tab-width 4))

(use-package calendar
  :custom
  ;; 'american
  (calendar-date-style 'iso))

(use-package compile
  :custom
  ;; nil
  (compilation-scroll-output 'first-error)
  :bind
  ("C-c r" . recompile))

(use-package cus-edit
  :custom
  ;; nil ;; (user-init-file)
  (custom-file (file-name-concat user-emacs-directory "custom.el")))

(use-package delsel
  :config
  (delete-selection-mode))

(use-package dired
  :custom
  ;; "-al"
  (dired-listing-switches "-Albh --group-directories-first")
  :bind
  ("C-x d" . dired-jump))

(use-package eglot
  :custom
  ;; 3
  (eglot-sync-connect nil)
  ;; 'confirm
  (eglot-confirm-server-initiated-edits nil)
  ;; nil
  (eglot-extend-to-xref t)
  ;; nil
  (eglot-autoshutdown t)
  :hook
  (prog-mode . eglot-ensure)
  (eglot-managed-mode-hook . eglot-inlay-hints-mode))

(use-package elec-pair
  :hook
  (prog-mode . electric-pair-local-mode))

(use-package executable
  :hook
  (after-save-hook . executable-make-buffer-file-executable-if-script-p))

(use-package faces
  :custom-face
  (default ((t (:family "Spleen 32x64")))))

(use-package filelock
  :no-require t
  :custom
  ;; t
  (create-lockfiles nil))

(use-package files
  :custom
  ;; t
  (make-backup-files nil))

(use-package frame
  :custom
  ;; '(tab-bar-lines tool-bar-lines)
  (frame-inhibit-implied-resize t)
  :config
  (set-frame-parameter nil 'alpha-background 90)
  (push '(alpha-background . 90) default-frame-alist))

(use-package fringe
  :custom
  (fringe-mode 0))

(use-package indent
  :no-require t
  :custom
  ;; t
  (tab-always-indent 'complete))

(use-package isearch
  :custom
  ;; nil
  (isearch-lazy-count t))

(use-package lread
  :no-require t
  :custom
  ;; nil
  (lexical-binding t))

(use-package mb-depth
  :config
  (minibuffer-depth-indicate-mode))

(use-package menu-bar
  :config
  (menu-bar-mode 0))

(use-package minibuf
  :no-require t
  :custom
  ;; nil
  (enable-recursive-minibuffers t))

(defun flo/enable-orgtbl ()
  (interactive)
  (let ((inhibit- t))
    (turn-on-orgtbl)))

(use-package org
  :defer 5
  :custom
  ;; "~/org"
  (org-directory "~/Roam/")
  ;; nil
  (org-log-done 'time)
  ;; nil
  (org-special-ctrl-a/e t)
  ;; nil
  (org-special-ctrl-k t)
  ;; nil
  (org-enforce-todo-dependenncies t)
  ;; nil
  (org-enforce-todo-checkbox-dependencies t)
  ;; 'reorganize-frame
  (org-src-window-setup 'current-window)
  ;; nil
  (org-refile-targets '((nil :level . 1)
                        (org-agenda-files :level 1)))
  ;; See: `org-structure-template-alist' / too long
  (org-structure-template-alist '(("e"   . "example")
                                  ("s"   . "src")
                                  ;; prog
                                  ("c"   . "src C")
                                  ("el"  . "src emacs-lisp")
                                  ("hs"  . "src haskell")
                                  ("jv"  . "src java")
                                  ("ml"  . "src ocaml")
                                  ("nix" . "src nix")
                                  ("sh"  . "src bash :sheband /usr/bin/env bash")
                                  ("py"  . "src python")))

  ;; org-babel

  ;; t
  (org-confirm-babel-evaluate nil)

  :config
  ;; https://emacs.stackexchange.com/questions/20577/org-babel-load-all-languages-on-demand
  (defadvice org-babel-execute-src-block (around load-language nil activate)
    "Load any language if needed"
    (let ((language (org-element-property :language (org-element-at-point))))
      (unless (cdr (assoc (intern language) org-babel-load-languages))
        (add-to-list 'org-babel-load-languages (cons (intern language) t))
        (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages))
      ad-do-it))

  ;; orgtbl

  :blackout orgtbl-mode
  :hook
  (text-mode-hook . flo/enable-orgtbl)

  ;; Agenda

  :custom
  ;; 1 (nil <=> today)
  (org-agenda-start-on-weekday nil)
  ;; nil
  (org-agenda-files (list org-directory))
  ;; nil
  (org-agenda-include-diary t)
  ;; nil
  (org-agenda-skip-deadline-if-done t)
  ;; nil
  (org-agenda-skip-scheduled-if-done t)
  ;; nil
  (org-agenda-skip-timestanp-if-done t)

  :bind
  ("C-c a" . org-agenda-list)

  ;; Looks

  :custom
  ;; nil ("...")
  (org-ellipsis " ..")
  ;; nil
  (org-pretty-entities t)
  ;; t
  (org-pretty-entities-include-sub-superscripts nil)
  ;; '()
  (org-hidden-keywords '(author date email subtitle title))
  ;; 'showeverything
  (org-startup-folded t)

  ;; org-cite

  :config
  ;; nil
  (setq org-cite-global-bibliography (list (file-name-concat org-directory "refs.bib"))))

(use-package org-tempo
  :after org)

(use-package oc-bibtex
  :after org)

(defun flo/show-trailing-whitespace ()
  (interactive)
  (setq-local show-trailing-whitespace t))

(defun flo/enable-line-numbers ()
  (interactive)
  (display-line-numbers-mode))

(defun flo/highlight-line-mode ()
  (interactive)
  (hl-line-mode))

(use-package prog-mode
  :custom
  ;; '()
  (prettify-symbols-alist '(("#+begin_src" . "𝝺")
                            ("#+end_src"   . "𝝺")))
  :hook
  ((org-mode text-mode)  . prettify-symbols-mode)
  ((prog-mode text-mode) . flo/show-trailing-whitespace)
  (prog-mode             . flo/enable-line-numbers)
  (prog-mode             . flo/highlight-line-mode))

(use-package savehist
  :config
  (savehist-mode))

(use-package scroll-bar
  :config
  (scroll-bar-mode 0))

(use-package simple
  :custom
  ;; t
  (indent-tabs-mode nil)
  :bind
  ("C-x k"                 . kill-current-buffer)
  ("C-x K"                 . kill-buffer)
  ("C-="                   . count-words)
  ([remap delete-char]     . delete-forward-char)
  ([remap capitalize-word] . capitalize-dwim)
  ([remap downcase-word]   . downcase-dwim)
  ([remap upcase-word]     . upcase-dwim))

(use-package startup
  :no-require t
  :custom
  ;; nil
  (inhibit-startup-screen t))

(use-package subr
  :no-require t
  :config
  (defalias 'yes-or-no-p 'y-or-n-p))

(use-package terminal
  :no-require t
  :custom
  ;; nil
  (ring-bell-function #'ignore))

(use-package time
  :custom
  ;; nil
  (display-time-24hr-format t)
  :config
  (display-time-mode))

(use-package tool-bar
  :config
  (tool-bar-mode 0))

(use-package tramp
  :custom
  ;; '(tramp-default-remote-path"
  ;;   "/bin" "/usr/bin" "/sbin" "/usr/sbin"
  ;;   "/usr/local/bin" "/usr/local/sbin"
  ;;   "/local/bin" "/local/freeware/bin"
  ;;   "/local/gnu/bin" "/usr/freeware/bin"
  ;;   "/usr/pkg/bin" "/usr/contrib/bin"
  ;;   "/opt/bin" "/opt/sbin" "/opt/local/bin")
  (tramp-remote-path '(tramp-default-remote-path tramp-own-remote-path)))

(use-package warnings
  :custom
  (warning-suppress-log-types '((comp) (org-roam))))

(defun flo/swap-buffer ()
  "Swap with the last buffer"
  (interactive)
  (switch-to-buffer (other-buffer)))

(defun flo/bol ()
  "Go to `BOL' or `INDENTATION-START' depending on cursor position in line."
  (interactive)
  (let* ((current (point))
         (at-indentation-p (save-excursion
                             (back-to-indentation)
                             (= current (point)))))
    (if at-indentation-p
        (beginning-of-line)
      (back-to-indentation))))

(use-package window
  :bind
  ("M-o" . flo/swap-buffer)
  ("C-a" . flo/bol))

(use-package winner
  :config
  (winner-mode))

(defun flo/enable-aggressive-indent-mode ()
  (interactive)
  (unless (derived-mode-p 'python-base-mode 'tuareg-mode)
    (aggressive-indent-mode)))

(use-package aggressive-indent
  :straight t
  :blackout t
  :hook
  (prog-mode . flo/enable-aggressive-indent-mode))

(use-package all-the-icons
  :straight t
  :when (display-graphic-p)
  :config
  (when (and (window-system)
             (not (find-font (font-spec :name "all-the-icons"))))
    (all-the-icons-install-fonts t)))

(use-package cape
  :straight t
  :config
  (push #'cape-dabbrev completion-at-point-functions)
  (push #'cape-file    completion-at-point-functions))

(use-package catppuccin-theme
  :straight t
  :custom-face
  (ansi-color-red ((t (:forgeground "#000000" :background "#f38ba8"))))
  (ansi-color-green ((t (:forgeground "#000000" :background "#a6e3a1"))))
  :custom
  (catppuccin-flavor 'mocha)
  :config
  (load-theme 'catppuccin t))

(use-package consult
  :straight t
  :hook
  (completion-list-mode . consult-preview-at-point-mode)
  :bind
  ([remap switch-to-buffer] . consult-buffer)
  ([remap yank-pop]         . consult-yank-pop)
  (:map minibuffer-local-map
        ("M-r" . consult-history)))

(defun flo/enable-corfu-auto ()
  (setq-local corfu-auto t
              completion-styles '(basic)))

(use-package corfu
  :straight t
  :demand t
  :custom
  ;; nil
  (corfu-cycle t)
  :config
  (global-corfu-mode)
  :hook
  (prog-mode . flo/enable-corfu-auto)
  :bind
  ("C-@" . completion-at-point))

(use-package crux
  :straight t
  :bind
  ("C-c P"   . crux-kill-buffer-truename)
  ("C-c e"   . crux-eval-and-replace)
  ("C-c d"   . crux-duplicate-current-line-or-region)
  ("C-c M-d" . crux-duplicate-and-comment-current-line-or-region))

(use-package diredfl
  :straight t
  :config
  (diredfl-global-mode))

(use-package direnv
  :straight t
  :config
  (direnv-mode))

(use-package engrave-faces
    :straight t
    :after org
    :custom
    ;; '()
    (org-latex-packages-alist '(("" "fvextra") ("" "listings")))
    ;; 'verbatim
    (org-latex-src-block-backend 'engraved))

(use-package exec-path-from-shell
  :straight t
  :config
  (exec-path-from-shell-initialize))

(use-package fancy-compilation
  :straight t
  ;; :custom-face
  ;; (fancy-compilation-default-face ((t (:inherit 'mode-line-inactive :background nil))))
  :config
  (fancy-compilation-mode)
  (advice-add 'recompile :around #'fancy-compilation--compile))

(use-package go-mode
  :straight t)

(use-package haskell-mode
  :straight t
  :hook
  (haskell-mode-hook . flymake-hlint-load))

(use-package helpful
  :straight t
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key]      . helpful-key)
  ([remap describe-command]  . helpful-command))

(use-package kind-icon
  :straight t
  :after corfu
  :custom
  ;; nil
  (kind-icon-default-face  'corfu-default)
  :config
  (push #'kind-icon-margin-formatter corfu-margin-formatters))

(use-package lua-mode
  :straight t)

(use-package magit
  :straight t
  :custom
  ;; t
  (magit-define-global-key-bindings nil)
  :bind
  ("C-c g" . magit))

(use-package magit-todos
  :straight t
  :after magit
  :config
  (magit-todos-mode))

(use-package marginalia
  :straight t
  :demand t
  :config
  (marginalia-mode)
  :bind
  (:map minibuffer-local-map
        ("M-a" . marginalia-cycle)))

(use-package markdown-mode
  :straight t
  :mode
  ("README(\\.md)?\\'" . gfm-mode))

(use-package nix-mode
  :straight t)

(dolist (var (car (read-from-string (shell-command-to-string "opam config env --sexp"))))
  (setenv (car var) (cadr var)))

(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic)))

(use-package org-appear
  :straight t
  :after org
  :custom
  ;; nil
  (org-appear-autoentities t)
  ;; nil
  (org-appear-autokeywords t)
  ;; nil
  (org-appear-autolinks t)
  :hook org-mode)

(use-package org-fragtog
  :straight t
  :after org
  :hook org-mode)

(use-package org-roam
  :straight t
  :after org
  :defer 5
  :custom
  ;; 100000000
  (org-roam-db-gc-threshold most-positive-fixnum)
  ;; "/home/flo/org-roam/"
  (org-roam-directory org-directory)
  ;; See `org-roam-catputre-templates' / too long
  (org-roam-capture-templates
   `(("d" "default" plain "%?" :target (file+head
                                        "${slug}.org"
                                        "#+title:${title}\n#+author:%n\n#+date:%<%F>\n"))))

  ;; "daily/"
  (org-roam-dailies-directory "daily/")
  ;; (("d" "default" entry "* %?" :target (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n")))
  (org-roam-dailies-capture-templates
   '(("d" "default" entry "* %^{title}\n"
      :target (file+head "%<%Y-%m-%d>.org" "#+title:daily %<%Y-%m-%d>\n#+author:%n\n\n")
      :empty-lines 1
      :immediate-finish t
      :jump-to-captured t)))

  :config
  (org-roam-db-autosync-mode)
  (push #'org-roam-complete-link-at-point completion-at-point-functions)

  :bind
  ("C-c f" . org-roam-node-find)
  ("C-c i" . org-roam-node-insert)
  ("C-c c" . org-roam-dailies-capture-today))

(use-package org-roam-export
  :after org-roam)

(use-package pdf-tools
  :straight t
  :config
  (pdf-loader-install))

(use-package projectile
  :straight t
  :blackout t
  :custom
  ;; #'projectile-find-file
  (projectile-switch-project-action #'projectile-dired)
  ;; nil
  (projectile-enable-caching t)
  :config
  (projectile-mode))

(use-package pulsar
  :straight t
  :custom
  ;; 'pulsar-generic
  (pulsar-face 'pulsar-magenta)
  :config
  (pulsar-mode))

(use-package puni
  :straight t
  :demand t
  :config
  (puni-global-mode)
  :bind
  ("C-*" . puni-expand-region))

(use-package rainbow-delimiters
  :straight t
  :hook
  ((prog-mode text-mode) . rainbow-delimiters-mode))

(use-package rainbow-identifiers
  :straight t
  :hook
  (prog-mode . rainbow-identifiers-mode))

(use-package rainbow-mode
  :straight t
  :blackout t
  :custom
  ;; see `rainbow-html-colors-alist' / too long to list
  (rainbow-html-colors-alist '())
  :hook
  ((prog-mode text-mode) . rainbow-mode))

(use-package rust-mode
  :mode "\\.rs\\'"
  :straight t)

(use-package scala-mode
  :straight t)

(use-package sly
  :straight t
  :custom
  (inferior-lisp-program "ccl"))

(use-package tuareg
  :straight t
  :custom
  ;; nil
  (tuareg-indent-align-with-first-arg t))

(use-package vertico
  :straight (:files ("*" "extensions/*" (:exclude ".git")))
  :custom
  ;; nil
  (vertico-cycle t)
  :config
  (vertico-mode))

(use-package vertico-directory
  :after vertico
  :bind
  (:map vertico-map
        ("<backspace>" . vertico-directory-delete-char))
  :hook
  (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package visual-fill-column
  :straight t
  :after org
  :custom
  ;; nil
  (visual-fill-column-enable-sensible-window-split t)
  ;; nil
  (visual-fill-column-width 150)
  ;; nil
  (visual-fill-column-center-text t)

  :hook org-mode)

(use-package web-mode
  :straight t
  :mode ("\\.html?\\'"
         "\\.php\\'"
         "\\.xml\\'"
         "\\.vue\\'"
         "\\.svelte\\'"))

(use-package which-key
  :straight t
  :config
  (which-key-mode))

(use-package ws-butler
  :straight t
  :blackout t
  :config
  (ws-butler-global-mode))

(use-package yaml-mode
  :straight t)

(use-package yasnippet
  :straight t
  :blackout yas-minnor-mode
  :custom
  ;; '("/home/flo/.emacs.d/snippets")
  (yas-snippet-dirs '("~/Snippets"))
  :config
  (yas-global-mode))
