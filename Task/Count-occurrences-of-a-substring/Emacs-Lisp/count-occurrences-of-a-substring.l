(defun count-substrings (text substring)
    (with-temp-buffer
      (insert text)
      (goto-char (point-min))
      (how-many substring)))
