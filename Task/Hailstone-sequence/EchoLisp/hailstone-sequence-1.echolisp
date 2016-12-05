(lib 'hash)
(lib 'sequences)
(lib 'compile)

(define (hailstone n)
(when (> n 1)
	(if (even? n) (/ n 2) (1+ (* n 3)))))
	
(define H (make-hash))

;; (iterator/f seed f) returns seed, (f seed) (f(f seed)) ...

(define (hlength seed)
	(define collatz (iterator/f hailstone seed))
	(or
	   (hash-ref H seed) ;; known ?
	   (hash-set H seed
	      (for ((i (in-naturals)) (h collatz))
              ;; add length of subsequence if already known
	      #:break (hash-ref H h) => (+ i (hash-ref H h))
	      (1+ i)))))
	
(define (task (nmax 100000))
	(for ((n [1 .. nmax])) (hlength n)) ;; fill hash table

	(define hmaxlength (apply max (hash-values H)))
	(define hmaxseed (hash-get-key H hmaxlength))
	(writeln 'maxlength= hmaxlength 'for hmaxseed))
