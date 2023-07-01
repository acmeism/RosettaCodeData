(defun string/integer-prompt-value (pane)
  (with-slots (string-pane integer-pane) pane
    (let* ((string (capi:text-input-pane-text string-pane))
           (integer-string (capi:text-input-pane-text integer-pane))
           (integer (when (every 'digit-char-p integer-string)
                      (parse-integer integer-string :junk-allowed t))))
      (values (cons string integer)))))
