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

(message "hahaha in the ccc mode")

(after! cc-mode
  (message "in the prifvate module")
  (push `+lookup-counsel-ctags-backend-fn +lookup-definition-functions)
  )
