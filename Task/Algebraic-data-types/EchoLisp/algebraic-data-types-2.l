(define (t-show n (depth 0))
	(when (!eq? 'empty n)
		(t-show (N-left n) (+ 12 depth))
		(writeln (string-pad-left (format "%s" n ) depth))
		(t-show (N-right n) (+ 12 depth))))

(define T (for/fold [t 'empty] ([i 32]) (insert (random 100) t)))
(t-show T)
