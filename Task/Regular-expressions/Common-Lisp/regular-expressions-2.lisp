(let* ((string "I am a string")
       (string (cl-ppcre:regex-replace " a " string " another ")))
  (write-line string))
