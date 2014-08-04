;;my super minor restart-node-after-save-mode
(define-minor-mode rnas-mode
  "Restart node.js after save."
  :lighter "rnas"
  :global t
  
  (defvar cur-buf nil)
  (defvar node-shell nil)

  (defvar start-script-command (concat "node " (read-file-name "Start script: ") "\n"))

  (defun run-script ()
    (process-send-string nil (concat "echo \"" start-script-command "\"\n"))
    (process-send-string nil (concat "sudo " start-script-command)))
  
  (defun start-node (name)
    "Invoke shell."
    (let ((buf (get-buffer-create (generate-new-buffer-name name))))
      (pop-to-buffer buf)
      (shell (current-buffer))
      (run-script)
      buf))
  
  (defun restart-node (buf)
    "Restart node."
    (pop-to-buffer buf)
    (interrupt-process "rnas-node" t)
    (run-script))

  (defun main ()
    (setq cur-buf (current-buffer))
    (if (equal (file-name-extension (or (buffer-file-name) ""))
               "js")
        (progn
          (if node-shell
              (restart-node node-shell)
            (setq node-shell (start-node "rnas-node")))
          (pop-to-buffer cur-buf))))
  
  (add-hook 'kill-emacs-hook
            (lambda ()
              (pop-to-buffer node-shell)
              (kill-process)))

  (add-hook 'kill-buffer-hook
            (lambda ()
              (if (equal (or (buffer-name) "")
                         "rnas-node")
                  (progn
                    (kill-process)
                    (setq node-shell nil)))))
  
  (add-hook 'after-save-hook
            (lambda ()
              (if rnas-mode
                  (main))))

  (main))

(provide 'rnas-mode)
