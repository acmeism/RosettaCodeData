;; sorting (name value) by name - Ignoring case
(define (name a) (first a))
(define( sort-proc a b)
    (string-ci<? (name a) (name b)))

(define people
   '(("😎" -42) ("albert" 33) ("Simone" 44) ("Antoinette" 42) ("elvis" 666) ("😃" 1000)))

(list-sort sort-proc people)
   → (("albert" 33) ("Antoinette" 42) ("elvis" 666) ("Simone" 44) ("😃" 1000) ("😎" -42))
