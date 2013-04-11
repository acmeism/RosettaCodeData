(define (power-seq n)
  (let ((i 0))
    (lambda ()
      (set! i (+ 1 i))
      (expt i n))))

(define (filter-seq m n)
  (let* ((s1 (power-seq m)) (s2 (power-seq n))
			    (a 0) (b 0))
    (lambda ()
      (set! a (s1))
      (let loop ()
	(if (>= a b) (begin
		       (cond ((> a b) (set! b (s2)))
			     ((= a b) (set! a (s1))))
		       (loop))))
      a)))

(let loop ((seq (filter-seq 2 3)) (i 0))
  (if (< i 30)
    (begin
      (if (> i 20)
	(begin
	  (display (seq))
	  (newline))
	(seq))
      (loop seq (+ 1 i)))))
