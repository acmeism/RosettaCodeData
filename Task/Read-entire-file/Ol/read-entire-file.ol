; simple way
(file->string "filename")

; r7rs way
(call-with-input-file "filename"
   (lambda (port)
      (read-string #f port)))
