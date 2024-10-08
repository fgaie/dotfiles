(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(indent-tabs-mode 0)
(global-hl-line-mode 1)

(savehist-mode 1)
(electric-pair-mode 1)
(minibuffer-depth-indicate-mode 1)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

(setq inhibit-startup-screen t)
(setq enable-recursive-minibuffers t)
(setq read-extended-command-predicate #'command-completion-default-include-p)
(setq tab-always-indent 'complete)
(setq make-backup-files nil)

(defalias 'yes-or-no-p 'y-or-n-p)

(set-face-font 'default "Iosevka Term SS01")

(push '(alpha-background . 90) default-frame-alist)

;; language ervers
(setq eglot-sync-connect nil)
(setq eglot-extend-to-xref t)
(setq eglot-autoshutdown t)
(add-hook 'prog-mode-hook 'eglot-ensure)

;; custom bindings
(defun flo/bol ()
  "Go to `BOL' or `INDENTATION-START' depending on cursor position."
  (interactive)
  (let* ((current (point))
         (at-indentation-p (save-excursion
                             (back-to-indentation)
                             (= current (point)))))
    (if at-indentation-p
        (beginning-of-line)
      (back-to-indentation))))

(defun flo/other-buffer ()
  "Swap to the last buffer"
  (interactive)
  (switch-to-buffer (other-buffer)))

(keymap-global-set "C-," 'duplicate-line)
(keymap-global-set "C-c c" 'compile)
(keymap-global-set "C-c r" 'recompile)
(keymap-global-set "C-x k" 'kill-current-buffer)
(keymap-global-set "C-x K" 'kill-buffer)
(keymap-global-set "C-a" 'flo/bol)
(keymap-global-set "M-o" 'flo/other-buffer)

;; packages

(use-package autothemer
  :straight t)

(use-package rose-pine-theme
  :straight (rose-pine-theme :type git :host github :repo "konrad1977/pinerose-emacs")
  :after autothemer
  :init (load-theme 'rose-pine t))

(use-package rainbow-delimiters
  :straight t
  :init (rainbow-delimiters-mode 1))

(use-package vertico
  :straight t
  :init (vertico-mode 1)
  :custom (vertico-cycle t))

(use-package vertico-directory
  :after vertico
  :bind (:map vertico-map
	      ("<backspace>" . vertico-directory-delete-char)))

(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))))
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t))

(use-package marginalia
  :straight t
  :init (marginalia-mode)
  :bind (:map minibuffer-local-map
	      ("M-a" . marginalia-cycle)))

(use-package consult
  :straight t
  :bind
  ([remap switch-to-buffer] . consult-buffer)
  ([remap goto-line] . consult-goto-line)
  (:map minibuffer-local-map
	("M-r" . consult-history)))

(use-package corfu
  :straight t
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-popupinfo-delay '0)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  :bind ("C-@" . completion-at-point))

(use-package kind-icon
  :straight t
  :after corfu
  :init (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package cape
  :straight t
  :init
  (push #'cape-dabbrev completion-at-point-functions)
  (push #'cape-emoji completion-at-point-functions)
  (push #'cape-file completion-at-point-functions)
  (push #'cape-keyword completion-at-point-functions))

(use-package ws-butler
  :straight t
  :init (ws-butler-global-mode))

(use-package puni
  :straight t
  :init (puni-global-mode 1)
  :bind ("C-*" . puni-expand-region))

(use-package which-key
  :straight t
  :init (which-key-mode 1))

(use-package helpful
  :straight t
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

(use-package geiser
  :straight t)

(use-package geiser-chicken
  :after geiser
  :straight t)

(use-package geiser-overlay
  :after geiser
  :straight t
  :bind ([remap geiser-eval-definition] . geiser-overlay-eval-defun))

(use-package multiple-cursors
  :straight t
  :bind
  ("C-<" . mc/mark-previous-like-this)
  ("C->" . mc/mark-next-like-this))

(use-package rainbow-delimiters
  :straight t
  :init (rainbow-delimiters-mode 1))
