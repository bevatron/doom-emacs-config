;; -*- coding: utf-8; lexical-binding: t; -*-

;; Don't ask before rereading the TAGS files if they have changed
(setq tags-revert-without-query t)
;; Do case-sensitive tag searches
(setq tags-case-fold-search nil) ;; t=case-insensitive, nil=case-sensitive
;; Don't warn when TAGS files are large
(setq large-file-warning-threshold nil)

;; Setup auto update now
(add-hook 'prog-mode-hook
          (lambda ()
            (add-hook 'after-save-hook
                      'counsel-etags-virtual-update-tags 'append 'local)))

(defun +lookup-counsel-ctags-backend-fn (_identifier)
  "Look up the symbol at point (or selection) with `dumb-jump', which conducts a
project search with ag, rg, pt, or git-grep, combined with extra heuristics to
reduce false positives.

This backend prefers \"just working\" over accuracy."
  (counsel-etags-find-tag-at-point)
  )

(after! cc-mode
  (push `+lookup-counsel-ctags-backend-fn +lookup-definition-functions)
  )

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  )

(use-package flycheck-clang-tidy
  :after flycheck
  :hook
  (flycheck-mode . flycheck-clang-tidy-setup)
  :init (setq flycheck-clang-tidy-executable "clang-tidy-12")
  )

(after! company
  (add-to-list 'company-backends 'company-etags)
  )

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (cc-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  ;; enable log only for debug
  (setq lsp-log-io nil)

  ;; use `evil-matchit' instead
  (setq lsp-enable-folding nil)

  ;; no real time syntax check
  (setq lsp-prefer-flymake :none)

  ;; handle yasnippet by myself
  (setq lsp-enable-snippet nil)

  ;; use `company-ctags' only.
  ;; Please note `company-lsp' is automatically enabled if installed
  (setq lsp-enable-completion-at-point nil)

  ;; turn off for better performance
  (setq lsp-enable-symbol-highlighting nil)

  ;; use ffip instead
  (setq lsp-enable-links nil)

  ;; don't scan some files
  (push "[/\\\\][^/\\\\]*\\.json$" lsp-file-watch-ignored) ; json

  ;; don't ping LSP lanaguage server too frequently
  (defvar lsp-on-touch-time 0)

  (defadvice lsp-on-change (around lsp-on-change-hack activate)
    ;; don't run `lsp-on-change' too frequently
    (when (> (- (float-time (current-time))
                lsp-on-touch-time) 30) ;; 30 seconds
      (setq lsp-on-touch-time (float-time (current-time)))
      ad-do-it))
  )
