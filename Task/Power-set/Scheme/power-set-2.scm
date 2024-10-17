(define (power-set lst)
  (define (iter yield)
    (let recur ((a '()) (b lst))
      (if (null? b) (set! yield
		      (call-with-current-continuation
			(lambda (resume)
			  (set! iter resume)
			  (yield a))))
	(begin (recur (append a (list (car b))) (cdr b))
	       (recur a (cdr b)))))

    ;; signal end of generation
    (yield 'end-of-seq))

  (lambda () (call-with-current-continuation iter)))

(define x (power-set '(1 2 3)))
(let loop ((a (x)))
  (if (eq? a 'end-of-seq) #f
    (begin
      (display a)
      (newline)
      (loop (x)))))
