(define (horner x poly)
(foldr (lambda (coeff acc) (+ coeff (* acc x))) 0 poly))

(horner 3 '(-19 7 -4 6)) → 128
