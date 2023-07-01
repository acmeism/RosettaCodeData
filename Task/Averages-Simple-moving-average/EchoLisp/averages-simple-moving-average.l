(lib 'tree) ;; queues operations


(define (make-sma p)
	(define Q (queue (gensym)))
	(lambda (item)
		(q-push Q item)
		(when (> (queue-length Q) p) (q-pop Q))
		(// (for/sum ((x (queue->list Q))) x)  (queue-length Q))))
		
