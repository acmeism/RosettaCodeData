(define icon (runes->string (bytevector->list (file->bytevector "favicon.ico"))))
(encode icon)
