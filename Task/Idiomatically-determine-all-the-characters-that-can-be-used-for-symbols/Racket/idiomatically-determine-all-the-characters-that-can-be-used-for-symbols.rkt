#lang racket
;; Symbols that don't need to be specially quoted:
(printf "~s~%" '(a a-z 3rd ...---... .hidden-files-look-like-this))

;; Symbols that do need to be specially quoted:
(define bar-sym-list
  `(|3|
    |i have a space|
    |i've got a quote in me|
    |i'm not a "dot on my own", but my neighbour is!|
    |.|
    ,(string->symbol "\u03bb")
    ,(string->symbol "my characters aren't even mapped in unicode \U10e443")))
(printf "~s~%" bar-sym-list)
(printf "~a~%" bar-sym-list)

(define (main)
  (for
      ((c (sequence-map
           integer->char
           (in-sequences (in-range 0 (add1 55295))
                         (in-range 57344 (add1 1114111)))))
       (i (in-naturals 1)))
    (when (zero? (modulo i 80)) (newline))
    (display (list->string (list c)))))
