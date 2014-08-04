;;;installed:
;;auto-complete
;;cider
;;clojure-mode
;;color-theme
;;color-theme-solarized
;;epl
;;expand-region
;;hackernews
;highlight-tail
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
(setq default-tab-width 4)
(global-hl-line-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(iswitchb-mode 1)
(column-number-mode t)
(setq-default truncate-lines t)
(setq x-select-enable-clipboard t)
(menu-bar-mode -1)
(delete-selection-mode 1)
;;linum mode forever
;;(global-linum-mode t)
;disable backup
(setq backup-inhibited t)
;disable auto save
(setq auto-save-default nil)
;;tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq sgml-basic-offset 4)

;;;common key bingings
(global-set-key [(control z)] nil)
(global-set-key [f8] 'linum-mode)
(global-set-key [control-shift-d] 'kill-word)
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
		("\\.cljs$". clojure-mode)
		("\\.php$" . php-mode))))

;;rnas-mode
(load "~/emacs.config/lib/rnas-mode.el")

;;web-mode settings
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-code-indent-offset 4))
(add-hook 'web-mode-hook  'my-web-mode-hook)

;;clojure preload settings (from emacs live)
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

;;auto-complete (from emacs live)
(add-to-list 'auto-mode-alist '("\\.el$" . emacs-lisp-mode))
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(define-key lisp-mode-shared-map (kbd "RET") 'reindent-then-newline-and-indent)
(defun live-lisp-describe-thing-at-point ()
  "Show the documentation of the Elisp function and variable near point.
   This checks in turn:
     -- for a function name where point is
     -- for a variable name where point is
     -- for a surrounding function call"
          (interactive)
          (let (sym)
            ;; sigh, function-at-point is too clever.  we want only the first half.
            (cond ((setq sym (ignore-errors
                               (with-syntax-table emacs-lisp-mode-syntax-table
                                 (save-excursion
                                   (or (not (zerop (skip-syntax-backward "_w")))
                                       (eq (char-syntax (char-after (point))) ?w)
                                       (eq (char-syntax (char-after (point))) ?_)
                                       (forward-sexp -1))
                                   (skip-chars-forward "`'")
                                   (let ((obj (read (current-buffer))))
                                     (and (symbolp obj) (fboundp obj) obj))))))
                   (describe-function sym))
                  ((setq sym (variable-at-point)) (describe-variable sym)))))
(defun live-lisp-top-level-p ()
  "Returns true if point is not within a given form i.e. it's in
  toplevel 'whitespace'. Only works for lisp modes."
  (= 0 (car (syntax-ppss))))
(defun live-check-lisp-top-level-p ()
  "Returns true if point is not within a given form i.e. it's in
  toplevel 'whitespace'. Only works for lisp modes."
  (interactive)
  (if (live-lisp-top-level-p)
      (message "top level")
    (message "not top level")))
(defun live-whitespace-at-point-p ()
  "Returns true if the char at point is whitespace"
  (string-match "[ \n\t]" (buffer-substring (point) (+ 1 (point)))))

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
;; Work around a bug on OS X where system-name is a fully qualified
;; domain name
(setq system-name (car (split-string system-name "\\.")))

;;clojure mode hook (from emacs live)
;;add-hook 'clojure-mode-hook
(add-hook 'clojure-mode-hook
          (lambda ()
            (message "clojure mode")

            ;;Treat hyphens as a word character when transposing words
            (defvar clojure-mode-with-hyphens-as-word-sep-syntax-table
              (let ((st (make-syntax-table clojure-mode-syntax-table)))
                (modify-syntax-entry ?- "w" st)
                st))
            (defun live-transpose-words-with-hyphens (arg)
              "Treat hyphens as a word character when transposing words"
              (interactive "*p")
              (with-syntax-table clojure-mode-with-hyphens-as-word-sep-syntax-table
                (transpose-words arg)))

            (define-key clojure-mode-map (kbd "M-t") 'live-transpose-words-with-hyphens)

            (define-key clojure-mode-map (kbd "C-:") 'cljr-cycle-stringlike)
            (define-key clojure-mode-map (kbd "C->") 'cljr-cycle-coll)

            (defun live-warn-when-cider-not-connected ()
              (interactive)
              (message "nREPL server not connected. Run M-x cider or M-x cider-jack-in to connect."))

            (define-key clojure-mode-map (kbd "C-M-x")   'live-warn-when-cider-not-connected)
            (define-key clojure-mode-map (kbd "C-x C-e") 'live-warn-when-cider-not-connected)
            (define-key clojure-mode-map (kbd "C-c C-e") 'live-warn-when-cider-not-connected)
            (define-key clojure-mode-map (kbd "C-c C-l") 'live-warn-when-cider-not-connected)
            (define-key clojure-mode-map (kbd "C-c C-r") 'live-warn-when-cider-not-connected)

            (setq  buffer-save-without-query t)

            ;; Pull in the awesome clj-refactor lib by magnars
            (clj-refactor-mode 1)
            (cljr-add-keybindings-with-prefix "C-c C-m")))

(dolist (x '(scheme emacs-lisp lisp clojure))
  (add-hook (intern (concat (symbol-name x) "-mode-hook")) 'enable-paredit-mode)
  (add-hook (intern (concat (symbol-name x) "-mode-hook")) 'rainbow-delimiters-mode))

;;;after init
(add-hook 'after-init-hook
          (lambda ()
            ;;undo-tree
            (global-undo-tree-mode)
            ;;yasnippet settings
            (setq live-yasnippet-dir "~/emacs.config/.yasnippets" live-etc-dir "snippets")
            (setq yas-snippet-dirs `(,live-yasnippet-dir))
            (yas-global-mode 1)

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
            (color-theme-solarized 'dark)

            ;;mic-paren
            (paren-activate)

            ;;key-chord
            (key-chord-mode 1)

            ;;recentf
            (recentf-mode t)
                                        ; 50 files ought to be enough.
            (setq recentf-max-saved-items 50)
 
            (defun ido-recentf-open () ;check
              "Use `ido-completing-read' to \\[find-file] a recent file"
              (interactive)
              (if (find-file (ido-completing-read "Find recent file: " recentf-list))
                  (message "Opening file...")
                (message "Aborting")))
            
            ;;magit (from emacs live)
            (add-hook 'magit-log-edit-mode-hook
                      (lambda ()
                        (set-fill-column 72)
                        (auto-fill-mode 1)))

            ;;auto-complete settings (from emacs live)
            (ac-config-default)
            (ac-flyspell-workaround)
            (add-to-list 'ac-dictionary-directories "~/emacs.config/.ac-dict")
            (setq ac-comphist-file "~/emacs.config/.emacs.tmp")

            (global-auto-complete-mode t)
            (setq ac-auto-show-menu t)
            (setq ac-dwim t)
            (setq ac-use-menu-map t)
            (setq ac-quick-help-delay 1)
            (setq ac-quick-help-height 60)
            (setq ac-disable-inline t)
            (setq ac-show-menu-immediately-on-auto-complete t)
            (setq ac-auto-start 2)
            (setq ac-candidate-menu-min 0)

            (set-default 'ac-sources
                         '(ac-source-dictionary
                           ac-source-words-in-buffer
                           ac-source-words-in-same-mode-buffers
                           ac-source-semantic
                           ac-source-yasnippet))

            (dolist (mode '(magit-log-edit-mode log-edit-mode org-mode text-mode haml-mode
                                                sass-mode yaml-mode csv-mode espresso-mode haskell-mode
                                                html-mode nxml-mode sh-mode smarty-mode clojure-mode
                                                lisp-mode textile-mode markdown-mode tuareg-mode))
              (add-to-list 'ac-modes mode))

            ;;cider settings (from emacs live)
            (defun live-windows-hide-eol ()
              "Do not show ^M in files containing mixed UNIX and DOS line endings."
              (interactive)
              (setq buffer-display-table (make-display-table))
              (aset buffer-display-table ?\^M []))

            (when (eq system-type 'windows-nt)
              (add-hook 'nrepl-mode-hook 'live-windows-hide-eol ))

            (add-hook 'cider-repl-mode-hook
                      (lambda ()
                        (cider-turn-on-eldoc-mode)
                        (paredit-mode 1)))

            (add-hook 'cider-mode-hook
                      (lambda ()
                        (cider-turn-on-eldoc-mode)
                        (paredit-mode 1)))

            (setq cider-popup-stacktraces nil)
            (setq cider-popup-stacktraces-in-repl nil)
            (add-to-list 'same-window-buffer-names "*cider*")

            ;;Auto Complete (for cider)
            (require 'ac-nrepl )

            (add-hook 'cider-mode-hook 'ac-nrepl-setup)
            (add-hook 'cider-repl-mode-hook 'ac-nrepl-setup)

            (eval-after-load "auto-complete"
              '(add-to-list 'ac-modes 'cider-mode))

            (setq nrepl-port "4555")

            ;;ido (from emacs live)
            (ido-mode t)
            (flx-ido-mode 1)
            (setq ido-enable-prefix nil
                  ido-create-new-buffer 'always
                  ido-max-prospects 10
                  ido-default-file-method 'selected-window
                  ido-everywhere 1)

            (icomplete-mode 1)

            (defvar live-symbol-names)
            (defvar live-name-and-pos)

            (defun live-recentf-ido-find-file ()
              "Find a recent file using ido."
              (interactive)
              (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
                (when file
                  (find-file file))))

            (defun live-ido-goto-symbol (&optional symbol-list)
              "Refresh imenu and jump to a place in the buffer using Ido."
              (interactive)
              (unless (featurep 'imenu)
                (require 'imenu nil t))
              (cond
               ((not symbol-list)
                (let ((ido-mode ido-mode)
                      (ido-enable-flex-matching
                       (if (boundp 'ido-enable-flex-matching)
                           ido-enable-flex-matching t))
                      live-name-and-pos live-symbol-names position selected-symbol)
                  (unless ido-mode
                    (ido-mode 1)
                    (setq ido-enable-flex-matching t))
                  (while (progn
                           (imenu--cleanup)
                           (setq imenu--index-alist nil)
                           (live-ido-goto-symbol (imenu--make-index-alist))
                           (setq selected-symbol
                                 (ido-completing-read "Symbol? " live-symbol-names))
                           (string= (car imenu--rescan-item) selected-symbol)))
                  (unless (and (boundp 'mark-active) mark-active)
                    (push-mark nil t nil))
                  (setq position (cdr (assoc selected-symbol live-name-and-pos)))
                  (cond
                   ((overlayp position)
                    (goto-char (overlay-start position)))
                   (t
                    (goto-char position)))))
               ((listp symbol-list)
                (dolist (symbol symbol-list)
                  (let (name position)
                    (cond
                     ((and (listp symbol) (imenu--subalist-p symbol))
                      (live-ido-goto-symbol symbol))
                     ((listp symbol)
                      (setq name (car symbol))
                      (setq position (cdr symbol)))
                     ((stringp symbol)
                      (setq name symbol)
                      (setq position
                            (get-text-property 1 'org-imenu-marker symbol))))
                    (unless (or (null position) (null name)
                                (string= (car imenu--rescan-item) name))
                      (add-to-list 'live-symbol-names name)
                      (add-to-list 'live-name-and-pos (cons name position))))))))

            ;;smex (from emacs live)
            (smex-initialize)
            (global-set-key (kbd "M-x") 'smex)
            (global-set-key (kbd "M-X") 'smex-major-mode-commands)
            ;; This is your old M-x.
            (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

            ;;popwin (from emacs live)
            (setq display-buffer-function 'popwin:display-buffer)

            (setq popwin:special-display-config
                  '(("*Help*"  :height 30)
                    ("*Completions*" :noselect t)
                    ("*Messages*" :noselect t :height 30)
                    ("*Apropos*" :noselect t :height 30)
                    ("*compilation*" :noselect t)
                    ("*Backtrace*" :height 30)
                    ("*Messages*" :height 30)
                    ("*Occur*" :noselect t)
                    ("*Ido Completions*" :noselect t :height 30)
                    ("*magit-commit*" :noselect t :height 40 :width 80 :stick t)
                    ("*magit-diff*" :noselect t :height 40 :width 80)
                    ("*magit-edit-log*" :noselect t :height 15 :width 80)
                    ("\\*ansi-term\\*.*" :regexp t :height 30)
                    ("*shell*" :height 30)
                    (".*overtone.log" :regexp t :height 30)
                    ("*gists*" :height 30)
                    ("*sldb.*":regexp t :height 30)
                    ("*cider-error*" :height 30 :stick t)
                    ("*cider-doc*" :height 30 :stick t)
                    ("*cider-src*" :height 30 :stick t)
                    ("*cider-result*" :height 30 :stick t)
                    ("*cider-macroexpansion*" :height 30 :stick t)
                    ("*Kill Ring*" :height 30)
                    ("*Compile-Log*" :height 30 :stick t)
                    ("*git-gutter:diff*" :height 30 :stick t)))

            (defun live-show-messages ()
              (interactive)
              (popwin:display-buffer "*Messages*"))

            (defun live-display-messages ()
              (interactive)
              (popwin:display-buffer "*Messages*"))

            (defun live-display-ansi ()
              (interactive)
              (popwin:display-buffer "*ansi-term*"))

            ;;term (from emacs live)
            (defcustom eshell-directory-name
              (let* ((dir "~/emacs.config/.emacs.tmp/eshell"))
                (make-directory dir t)
                dir)
              "The directory where Eshell control files should be kept."
              :type 'directory
              :group 'eshell)

            ;;make sure ansi colour character escapes are honoured
            (require 'ansi-color)
            (ansi-color-for-comint-mode-on)

            ;; kill buffer when terminal process is killed
            (defadvice term-sentinel (around my-advice-term-sentinel (proc msg))
              (if (memq (process-status proc) '(signal exit))
                  (let ((buffer (process-buffer proc)))
                    ad-do-it
                    (kill-buffer buffer))
                ad-do-it))
            (ad-activate 'term-sentinel)

            (defun live-term-use-utf8 ()
              (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
            (add-hook 'term-exec-hook 'live-term-use-utf8)

            (defun live-term-paste (&optional string)
              (interactive)
              (process-send-string
               (get-buffer-process (current-buffer))
               (if string string (current-kill 0))))

            (defun live-term-hook ()
              (goto-address-mode)
              (define-key term-raw-map "\C-y" 'live-term-paste))

            (add-hook 'term-mode-hook 'live-term-hook)

            ;; rotational ansi-terms
            (setq live-current-ansi-term nil)
            (setq live-ansi-terminal-path "/usr/local/bin/zsh")

            (defun live-ansi-term (program &optional new-buffer-name)
              "Start a terminal-emulator in a new buffer but don't switch to
              it. Returns the buffer name of the newly created terminal."
              (interactive (list (read-from-minibuffer "Run program: "
                                                       (or explicit-shell-file-name
                                                           (getenv "ESHELL")
                                                           (getenv "SHELL")
                                                           "/bin/sh"))))

              ;; Pick the name of the new buffer.
              (setq term-ansi-buffer-name
                    (if new-buffer-name
                        new-buffer-name
                      (if term-ansi-buffer-base-name
                          (if (eq term-ansi-buffer-base-name t)
                              (file-name-nondirectory program)
                            term-ansi-buffer-base-name)
                        "ansi-term")))

              (setq term-ansi-buffer-name (concat "*" term-ansi-buffer-name "*"))

              ;; In order to have more than one term active at a time
              ;; I'd like to have the term names have the *term-ansi-term<?>* form,
              ;; for now they have the *term-ansi-term*<?> form but we'll see...

              (setq term-ansi-buffer-name (generate-new-buffer-name term-ansi-buffer-name))
              (setq term-ansi-buffer-name (term-ansi-make-term term-ansi-buffer-name program))

              (set-buffer term-ansi-buffer-name)
              (term-mode)
              (term-char-mode)

              ;; I wanna have find-file on C-x C-f -mm
              ;; your mileage may definitely vary, maybe it's better to put this in your
              ;; .emacs ...

              (term-set-escape-char ?\C-x)
              term-ansi-buffer-name)

            (defun live-ansi-terminal-buffer-names ()
              (live-filter (lambda (el) (string-match "\\*ansi-term\\.*" el)) (live-list-buffer-names)))

            (defun live-show-ansi-terminal ()
              (interactive)
              (when (live-empty-p (live-ansi-terminal-buffer-names))
                (live-ansi-term live-ansi-terminal-path))

              (when (not live-current-ansi-term)
                (setq live-current-ansi-term (car (live-ansi-terminal-buffer-names))))

              (popwin:display-buffer live-current-ansi-term))

            (defun live-new-ansi-terminal ()
              (interactive)
              (let* ((term-name (buffer-name (live-ansi-term live-ansi-terminal-path))))
                (setq live-current-ansi-term term-name)
                (popwin:display-buffer live-current-ansi-term)))


            ;;win-switch (from emacs live)
            (setq win-switch-feedback-background-color "DeepPink3")
            (setq win-switch-feedback-foreground-color "black")
            (setq win-switch-window-threshold 1)
            (setq win-switch-idle-time 0.7)

            ;; disable majority of shortcuts
            (win-switch-set-keys '() 'up)
            (win-switch-set-keys '() 'down)
            (win-switch-set-keys '() 'left)
            (win-switch-set-keys '() 'right)
            (win-switch-set-keys '("o") 'next-window)
            (win-switch-set-keys '("p") 'previous-window)
            (win-switch-set-keys '() 'enlarge-vertically)
            (win-switch-set-keys '() 'shrink-vertically)
            (win-switch-set-keys '() 'shrink-horizontally)
            (win-switch-set-keys '() 'enlarge-horizontally)
            (win-switch-set-keys '() 'other-frame)
            (win-switch-set-keys '("C-g") 'exit)
            (win-switch-set-keys '() 'split-horizontally)
            (win-switch-set-keys '() 'split-vertically)
            (win-switch-set-keys '() 'delete-window)
            (win-switch-set-keys '("\M-\C-g") 'emergency-exit)

            ;; OS X specific configuration (from emacs live)
            ;; Ensure the exec-path honours the shell PATH
            (exec-path-from-shell-initialize)

            ;; Ignore .DS_Store files with ido mode
            (add-to-list 'ido-ignore-files "\\.DS_Store")))
