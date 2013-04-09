#lang racket

(define (plural n)
  (string-append (number->string n) " bottle" (if (equal? n 1) "" "s")))

(define (sing bottles)
    (printf "~a of beer on the wall\n~a of beer\nTake on down, pass it around\n~a of beer on the wall\n\n"
            (plural bottles) (plural bottles) (plural (sub1 bottles))))

(for ((i (in-range 100 0 -1)))
  (sing i))
