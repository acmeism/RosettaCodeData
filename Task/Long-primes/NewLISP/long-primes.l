;;;	Using the fact that 10 has to be a primitive root mod p
;;;	for p to be a reptend/long prime.
;;;	p supposed prime and >= 7
(define (cycle-mod p)
	(let (n 10 tally 1)
		(while (!= n 1)
			(++ tally)
			(setq n (% (* n 10) p))
			tally)))
;
;;;	Primality test
(define (prime? n)
	(= (length (factor n)) 1))
;
;;;	Reptend test (p >= 7)
(define (reptend? p)
	(if (prime? p)
		(= (- p (cycle-mod p)) 1)
		false))
;
;;;	Find reptends in interval 7 .. n
(define (find-reptends n)
	(filter reptend? (sequence 7 n)))
;
;;;	Task
(println (find-reptends 500))
(println (map (fn(n) (println n " --> " (length (find-reptends n)))) '(500 1000 2000 4000 8000 16000 32000 64000)))
