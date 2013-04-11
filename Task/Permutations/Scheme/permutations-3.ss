(define (perm s)
  (cond ((null? s) '())
	((null? (cdr s)) (list s))
	(else ;; extract each item in list in turn and perm the rest
	  (let splice ((l '()) (m (car s)) (r (cdr s)))
	    (append
	      (map (lambda (x) (cons m x)) (perm (append l r)))
	      (if (null? r) '()
		(splice (cons m l) (car r) (cdr r))))))))

(display (perm '(1 2 3)))
