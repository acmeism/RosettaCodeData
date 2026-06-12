#lang racket/base

;; Rename only necessary so we can distinguish it
(require (rename-in math/number-theory [coprime? number-theory/coprime?]))

(define (gcd/coprime? . ns)
  (= 1 (apply gcd ns)))

(module+ main
  (define ((Coprimes name coprime?) test)
    (printf "~a: ~a -> ~a~%" name (cons 'coprime? test) (apply coprime? test)))
  (define tests '([21 15] [17 23] [36 12] [18 29] [60 15] [21 15 27] [17 23 46]))

  (for-each (λ (n f) (for-each (Coprimes n f) tests))
            (list "math/number-theory"
                  "named gcd-based function"
                  "anonymous gcd-based function")
            (list number-theory/coprime?
                  gcd/coprime?
                  (λ ns (= 1 (apply gcd ns))))))
