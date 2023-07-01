(defun sum-of-squares (vec)
    (defun sumsq (xs)
        (if (null xs)
            0
            (+ (expt (car xs) 2) (sumsq (cdr xs)))))
    (sumsq (vector->list vec)))

(define first-seven-primes #(2 3 5 7 11 13 17))

(define zero-length-vector #())

(print `(the sum of the squares of the first seven prime numbers is ,(sum-of-squares first-seven-primes)))

(print `(the sum of the squares of no numbers at all is ,(sum-of-squares zero-length-vector)))
