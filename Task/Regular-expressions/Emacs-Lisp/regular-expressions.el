(let ((string "I am a string"))
  (when (string-match-p "string$" string)
    (message "Ends with 'string'"))
  (message "%s" (replace-regexp-in-string " a " " another " string)))
