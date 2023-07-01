#lang typed/racket
(: lcs (String String -> String))
(define (lcs a b)
  (: all-substrings# (String -> (HashTable String Boolean)))
  (define (all-substrings# str)
    (define l (string-length str))
    (for*/hash : (HashTable String Boolean)
      ((s (in-range 0 l)) (e (in-range (add1 s) (add1 l))))
      (values (substring str s e) #t)))

  (define a# (all-substrings# a))

  (define b# (all-substrings# b))

  (define-values (s l)
    (for/fold : (Values String Nonnegative-Integer)
    ((s "") (l : Nonnegative-Integer 0))
    ((a_ (in-hash-keys a#))
     #:when (and (> (string-length a_) l) (hash-ref b# a_ #f)))
    (values a_ (string-length a_))))

  s)

(module+ test
  ("thisisatest" . lcs . "testing123testing"))
