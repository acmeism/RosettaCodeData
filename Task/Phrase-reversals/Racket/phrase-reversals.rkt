#lang racket/base
(require
  (only-in srfi/13 string-reverse)
  (only-in racket/string string-split string-join))

(define (phrase-reversal s)
  (list
   (string-reverse s)
   (string-join (map string-reverse (string-split s)))
   (string-join (reverse (string-split s)))))

(for-each displayln (phrase-reversal "rosetta code phrase reversal"))
