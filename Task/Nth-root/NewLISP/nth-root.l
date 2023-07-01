(define (nth-root n a)
  (let ((x1 a)
	(x2 (div a n)))
    (until (= x1 x2)
      (setq x1 x2
	    x2 (div
		(add
		 (mul x1 (- n 1))
		 (div a (pow x1 (- n 1))))
		n)))
    x2))
