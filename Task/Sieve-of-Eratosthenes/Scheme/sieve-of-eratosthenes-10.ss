 (define (primes-stream-ala-Bird)
   (define (mults p) (from-By (* p p) (* 2 p)))
   (define odd-primes                                          ;; primes are
       (s-cons 3 (s-diff (from-By 5 2)                         ;;  odds, without
                  (s-linear-join (s-map mults odd-primes)))))  ;;   multiples of primes
   (s-cons 2 odd-primes))

 ;;;; join streams using linear structure
 (define (s-linear-join sts)
   (s-cons (head (head sts)) (s-union (tail (head sts))
                               (s-linear-join (tail sts)))))
