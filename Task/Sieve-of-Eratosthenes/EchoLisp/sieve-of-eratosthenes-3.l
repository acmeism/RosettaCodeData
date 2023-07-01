;; 2x3 wheel
(define (weratosthenes n)
  (define primes (make-bit-vector n )) ;; everybody to #f (false)
  (bit-vector-set! primes 2 #t)
  (bit-vector-set! primes 3 #t)
  (bit-vector-set! primes 5 #t)

  (for ([i  (in-range 6 n 6) ]) ;; set candidate primes
  		(bit-vector-set! primes (1+ i) #t)
  		(bit-vector-set! primes (+ i 5) #t)
  		)
  		
  (for ([p  (in-range 5 (1+ (sqrt n)) 2 ) ])
  		 #:when (bit-vector-ref primes  p)
         (for ([j (in-range (* p p) n p)])
    (bit-vector-set! primes j #f)))
   primes)
