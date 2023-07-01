(lib 'match)
(define-syntax-rule (: v i) (vector-ref v i))
(reader-infix ':) ;; abbrev (vector-ref v i) === [v : i]


(lib 'bigint)
(define cprimes (list->vector (primes 10000)))

;; generates next k-almost-prime < pmax
;; c = vector of k primes indices c[i] <= c[j]
;; p = vector of intermediate products prime[c[0]]*prime[c[1]]*..
;; p[k-1] is the generated k-almost-prime
;; increment one c[i] at each step

(define (almost-next pmax k c p)
    (define almost-prime #f)
    (define cp 0)

    (for ((i (in-range (1- k) -1 -1))) ;; look backwards for c[i] to increment
        (vector-set! c i (1+ [c : i])) ;; increment c[i]
        (set! cp [cprimes : [c : i]])
        (vector-set! p i (if (> i 0) (* [ p : (1- i)] cp) cp)) ;; update partial product
			
        (when (< [p : i) pmax)
	    (set! almost-prime
            (and  ;; set followers to c[i] value
	       (for ((j (in-range (1+ i) k)))
	       (vector-set! c j [c : i])
	       (vector-set! p j (*  [ p : (1- j)] cp))
	       #:break (>= [p : j] pmax) => #f )
	       [p  : (1- k)]
	  ) ;; // and
	  ) ;; set!
	  ) ;; when
    #:break almost-prime
    ) ;; // for i
    almost-prime )

;; not sorted list of k-almost-primes < pmax
(define (almost-primes k nmax)
    (define base (expt 2 k)) ;; first one is 2^k
    (define pmax (* base nmax))
    (define c (make-vector k #0))
    (define p (build-vector k (lambda(i) (expt #2 (1+ i)))))
		
    (cons base
	(for/list
	((almost-prime (in-producer almost-next pmax k c p )))
	 almost-prime)))
			
