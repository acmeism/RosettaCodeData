 (define odd-primes
   (s-cons 3 (s-diff (from-By 5 2)
     (s-foldr (lambda (p r) (let ((q (* p p)))
                 (s-cons q (s-union (from-By (+ q (* 2 p)) (* 2 p)) r))))
             '() odd-primes))))

 (define primes (s-cons 2 odd-primes))

 ;;;; TODO: implement s-foldr function
