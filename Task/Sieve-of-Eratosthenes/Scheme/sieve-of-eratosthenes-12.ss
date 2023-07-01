(define (nthPrime n)
  (let nxtprm ((cnt 0) (ps (birdPrimes)))
    (if (< cnt n) (nxtprm (+ cnt 1) ((cdr ps))) (car ps))))
(nthPrime 1000000)
