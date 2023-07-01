;; stern (2n ) = stern (n)
;; stern(2n+1) = stern(n) + stern(n+1)

(define (stern n)
	(cond
		(( < n 3) 1)
		((even? n) (stern (/ n 2)))
		(else (let ((m (/ (1- n) 2))) (+ (stern m) (stern (1+ m)))))))
(remember 'stern)
