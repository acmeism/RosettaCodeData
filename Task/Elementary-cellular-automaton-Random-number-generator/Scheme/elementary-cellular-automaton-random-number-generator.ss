; uses SRFI-1 library http://srfi.schemers.org/srfi-1/srfi-1.html

(define (random-r30 n)
  (let ((r30 (vector 0 1 1 1 1 0 0 0)))
    (fold
      (lambda (x y ls)
	(if (= x 1)
	  (cons (* x y) ls)
	  (cons (+ (car ls) (* x y)) (cdr ls))))
      '()
      (circular-list 1 2 4 8 16 32 64 128)
      (unfold-right
	(lambda (x) (zero? (car x)))
	cadr
	(lambda (x) (cons (- (car x) 1)
			  (evolve (cdr x) r30)))
	(cons (* 8 n) (cons 1 (make-list 79 0))))))) ; list

(random-r30 10)
