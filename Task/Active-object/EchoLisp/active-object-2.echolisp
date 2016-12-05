(define (experiment)
	(define (K t) (sin (*  PI t )))
	(define A (make-active))
	(define (stop)  (A 'input 0))
	(define (sample t) (A 'sample (// t 1000)))
	(define (result) (writeln 'result (A 'output)))
	
	(at 2.5 'seconds 'result)
	(every 10 'sample) ;; integrate every 10 ms
	
	(A 'input K)
	(wait 2000 'stop))

(experiment) →
    3/7/2015 20:34:18 : result
    result     0.0002266920372221955
(experiment)  →
    3/7/2015 20:34:28 : result
    result     0.00026510586971023164
