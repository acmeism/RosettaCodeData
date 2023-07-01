;; trying the 16 combinations
;; all return the integer 1

(lib 'bigint)
(define zeroes '(integer: 0 inexact=float: 0.000 complex: 0+0i bignum: #0))
(for* ((z1 zeroes) (z2 zeroes)) (write (expt z1 z2)))
    →  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
