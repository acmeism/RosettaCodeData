#lang racket
(require racket/require
         ;; grab all "mod*" names, but get them without the "mod", so
         ;; `+' and `expt' is actually `mod+' and `modexpt'
         (filtered-in (λ(n) (and (regexp-match? #rx"^mod" n)
                                 (regexp-replace #rx"^mod" n "")))
                      math)
         (only-in math with-modulus))
(define (f x) (+ (expt x 100) x 1))
(with-modulus 13 (f 10))
;; => 1
