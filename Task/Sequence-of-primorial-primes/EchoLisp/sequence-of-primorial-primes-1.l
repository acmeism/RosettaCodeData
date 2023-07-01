(lib 'timer) ;; for (every (proc t) interval)
(lib 'bigint)

;; memoize primorial
(define p1000 (cons 1 (primes 1000))) ; remember first 1000 primes
(define (primorial n)
    (if(zero? n) 1
    (* (list-ref p1000 n) (primorial (1- n)))))
(remember 'primorial)

(define N 0)

;; search one at a time
(define (search t) ;; time parameter, set by (every),  not used
(set! N (1+ N))
(if (or (prime? (1+ (primorial N))) (prime? (1- (primorial N))))
	(writeln 'HIT N )
 	(writeln N (date->time-string (current-date )))))
