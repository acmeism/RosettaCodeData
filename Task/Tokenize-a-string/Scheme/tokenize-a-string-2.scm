(define s "Hello,How,Are,You,Today")
(define words (string-tokenize s (char-set-complement (char-set #\,))))
(define t (string-join words "."))
