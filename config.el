;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; tab-width
;;(setq tab-width 8)

(setq display-line-numbers-type nil)

;; font set
(setq doom-font (font-spec :family "Source Code Pro" :size 16)
      doom-variable-pitch-font (font-spec :family "Source Code Pro")
      doom-unicode-font (font-spec :family "DejaVu Sans Mono")
      doom-big-font (font-spec :family "Source Code Pro" :size 23))

(after! cc-mode
  (setenv "MANWIDTH" "72")
  (add-hook! 'c-mode-hook #'MyCHook)
  (add-hook! 'c++-mode-hook #'MyCHook)
  (add-hook! 'java-mode-hook #'MyCHook)

  (map! :after cc-mode :map c-mode-base-map :leader
        (:prefix-map ("s" . "search")
         :desc "Jump to char"    "c" #'evil-avy-goto-char
         ))
  )

(after! lsp-mode
  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 1024 1024))
  (setq lsp-idle-delay 1.500)
  (setq lsp-enable-file-watchers nil)
  )

(after! text-mode
  (add-to-list 'auto-mode-alist '("\\.tc\\'" . text-mode))
  (add-to-list 'auto-mode-alist '("\\.ev\\'" . text-mode))
  (add-to-list 'auto-mode-alist '("\\.conf\\'" . text-mode))
  (add-hook! 'text-mode-hook #'MyTextHook)
  )

(after! format
  (set-formatter! 'autopep8 '("autopep8" "--aggressive" "--aggressive" "-") :modes '(python-mode))
  (setq +format-with 'clang-format)
  (setq +format-on-save-enabled-modes
        '(not sql-mode         ; sqlformat is currently broken
              tex-mode         ; latexindent is broken
              latex-mode))
  )

(add-hook! 'python-mode-hook #'MyPythonHook)

(add-hook! 'asm-mode-hook #'MyASMHook)

;; C/C++ style hook
(defun MyCHook ()
  (setq c-doc-comment-style
        '((c-mode . 'gtkdoc)
          (c++-mode . 'gtkdoc)
          ))

  (setq fci-rule-column '80)
  (setq fci-rule-width 5)
  (fci-mode)

  (whitespace-mode)

  (which-func-mode)

  ;; "setup shared by all languages (java/groovy/c++ ...)"
  (setq c-basic-offset 8)
  (setq tab-width 8)
  (setq indent-tabs-mode t)

  ;; add hoook manually since (format +save) break curor of other window for the same buffer
  (add-hook! 'before-save-hook #'format-all-buffer)

  (c-set-offset 'innamespace 0)
  (c-set-offset 'substatement-open 0)

  (setq comment-start "/* " comment-end " */")
  ;;  (c-set-offset 'case-label '+)
  (c-toggle-comment-style -1)

  (setq display-line-numbers nil)
  )

(defun MyTextHook ()
  (setq-local fci-rule-column '80)
  (setq-local fci-rule-width 5)
  (fci-mode)

  (whitespace-mode)

  (setq display-line-numbers nil)

  ;; "setup shared by all languages (java/groovy/c++ ...)"
  (setq-local c-basic-offset 8)
  (setq-local tab-width 8)
  (setq-local indent-tabs-mode t)
  ;; (setq indent-tabs-mode nil)
  (c-set-offset 'innamespace 0)
  (c-set-offset 'substatement-open 0)

  ;; (setq comment-start "/* " comment-end " */")
  (setq-local comment-start "// ")
  (setq-local comment-end "")
  (setq-local indent-line-function (quote indent-to-left-margin))
  ;;  (c-set-offset 'case-label '+)
  )

(defun MyPythonHook ()
  (setq-local fci-rule-column '80)
  (setq-local fci-rule-width 5)
  (fci-mode)

  (setq display-line-numbers nil)

  ;;(setq indent-tabs-mode nil)

  ;; add hoook manually since (format +save) break curor of other window for the same buffer
  (add-hook! 'before-save-hook #'format-all-buffer)

  (which-func-mode)
  )

(defun MyASMHook ()
  (setq-local fci-rule-column '80)
  (setq-local fci-rule-width 5)
  (fci-mode)

  (setq display-line-numbers nil)
  (setq indent-tabs-mode t)

  (whitespace-mode)
  )

;;(set-formatter! 'clang-format \"clang-format\" :modes '(c-mode))
