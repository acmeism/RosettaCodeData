#lang racket
(string-ref "1234" 2)
(string-length "123")
(string-append "12" "34")
;exceptions:
(append (list 1 2) (list 3 4))
(unbox (box 7))
