;;installed:
;;auto-complete
;;cider
;;clojure-mode
;;color-theme
;;color-theme-solarized
;;epl
;;expand-region
;;hackernews
;;highlight-tail
;;js2-mode
;;less-css-mode
;;magit
;;mic-paren
;;org
;;org-ac
;;paredit
;;php-mode
;;pkg-info
;;undo-tree
;;wc-mode
;;web-mode
;;yasnippet

;;;most common stuff
(set-language-environment 'UTF-8)
(global-font-lock-mode 1)
(setq scroll-step 1)
(global-hl-line-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(column-number-mode t)
(setq-default truncate-lines t)
(setq x-select-enable-clipboard t)
(menu-bar-mode -1)
(delete-selection-mode 1)
(ido-mode 1)
;;disable backup
(setq backup-inhibited t)
(setq auto-save-default nil)
;;tabs
(setq-default indent-tabs-mode nil)
(setq default-tab-width 2)
(custom-set-variables '(coffee-tab-width 2))
;;tabs settings for web-mode 
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook  'my-web-mode-hook)

;;;common key bingings
(global-set-key [(control z)] nil)
(global-set-key [f8] 'linum-mode)
(global-set-key [(control g)] 'delete-backward-char)

;;;package archives
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

;;;ext-mode map
(setq auto-mode-alist
      (append '(("\\.el$". emacs-lisp-mode)
                (".emacs". emacs-lisp-mode)
                ("\\.html$". web-mode)
                ("\\.xml$". web-mode)
                ("\\.js$". js2-mode)
                ("\\.cpp$". c++-mode)
                ("\\.h$". c++-mode)
                ("\\.less$". less-css-mode)
                ("\\.styl$". css-mode)
                ("\\.clj$". clojure-mode)
                ("\\.cljs$". clojure-mode))))

;;;after init
(add-hook 'after-init-hook
          (lambda ()
            ;;undo-tree
            (global-undo-tree-mode)
            ;;yasnippet settings
            ;; (setq live-yasnippet-dir "~/emacs.config/.yasnippets" live-etc-dir "snippets")
            ;; (setq yas-snippet-dirs `(,live-yasnippet-dir))
            ;; (yas-global-mode 1)

            ;;wc
            (setq wc-modeline-format "WC[%tc, %tw]")

            ;;lang-pack
            (autoload 'glsl-mode "glsl-mode" nil t)
            (add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
            (add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))
            (add-to-list 'auto-mode-alist '("\\.glsl\\'" . glsl-mode))

            ;;color-theme
            (color-theme-initialize)
            (setq color-theme-is-global t)
            (color-theme-solarized 'light)

            ;;mic-paren
            (paren-activate)

            ;;key-chord
            (key-chord-mode 1)

            ;;recentf
            (recentf-mode t)
                                        ; 50 files ought to be enough.
            (setq recentf-max-saved-items 50)

            ;; OS X specific configuration (from emacs live)
            ;; Ensure the exec-path honours the shell PATH
            (exec-path-from-shell-initialize)

            ;; Work around a bug on OS X where system-name is a fully qualified
            ;; domain name
            (setq system-name (car (split-string system-name "\\.")))))

;; clojure visual sugar (from emacs live)
(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("(\\(fn\\)[\[[:space:]]"
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "λ")
                               nil))))))
(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("\\(#\\)("
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "ƒ")
                               nil))))))
(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("\\(#\\){"
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "∈")
                               nil))))))
(eval-after-load 'find-file-in-project
  '(add-to-list 'ffip-patterns "*.clj"))

;; OS X specific configuration (from emacs live)
(setq default-input-method "MacOSX")
;; Make cut and paste work with the OS X clipboard
(defun live-copy-from-osx ()
  (shell-command-to-string "pbpaste"))
(defun live-paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))
 (when (not window-system)
   (setq interprogram-cut-function 'live-paste-to-osx)
   (setq interprogram-paste-function 'live-copy-from-osx))

(dolist (x '(scheme emacs-lisp lisp clojure))
  (add-hook (intern (concat (symbol-name x) "-mode-hook")) 'enable-paredit-mode)
  (add-hook (intern (concat (symbol-name x) "-mode-hook")) 'rainbow-delimiters-mode))
