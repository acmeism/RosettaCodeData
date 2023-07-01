;;;	Practically identical to the EchoLisp solution
(define (semiprime? n)
	(= (length (factor n)) 2))
;
;;;	Example (sadly factor doesn't accept bigints)
(println (filter semiprime? (sequence 2 100)))
(setq x 9223372036854775807)
(while (not (semiprime? x)) (-- x))
(println "Biggest semiprime reachable: " x " = " ((factor x) 0) " x " ((factor x) 1))
