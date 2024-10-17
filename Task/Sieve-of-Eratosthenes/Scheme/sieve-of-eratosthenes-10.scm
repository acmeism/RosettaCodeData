 (define (primes-stream-ala-Bird)
   (define (mults p) (from-By (* p p) p))
   (define primes                                          ;; primes are
       (s-cons 2 (s-diff (from-By 3 1)                     ;;  numbers > 1, without
                  (s-linear-join (s-map mults primes)))))  ;;   multiples of primes
   primes)

 ;;;; join streams using linear structure
 (define (s-linear-join sts)
   (s-cons (head (head sts))
           (s-union (tail (head sts))
                    (s-linear-join (tail sts)))))
