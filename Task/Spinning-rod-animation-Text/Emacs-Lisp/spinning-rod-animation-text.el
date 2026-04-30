(while t
  (dolist (char (string-to-list "\\|/-"))
    (message "%c" char)
    (sit-for 0.25)))
