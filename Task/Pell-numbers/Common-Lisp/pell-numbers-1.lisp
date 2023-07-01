(defun recurrent-sequence-2 (a0 a1 k1 k2 max)
 "A generic function for any recurrent sequence of order 2, where a0 and a1 are the initial elements,
  k1 is the factor of a(n-1) and k2 is the factor of a(n-2)"
	(do* ((i 0 (1+ i))
	      (result (list a1 a0))
	      (b0 a0 b1)
	      (b1 a1 b2)
	      (b2 (+ (* k1 b1) (* k2 b0)) (+ (* k1 b1) (* k2 b0))) )
	  	((> i max) (nreverse result))
		(push b2 result) ))

(defun pell-sequence (max)
	(recurrent-sequence-2 0 1 2 1 max) )

(defun pell-lucas-sequence (max)
	(recurrent-sequence-2 2 2 2 1 max) )

(defun fibonacci-sequence (max) ; As an extra bonus, you get Fibonacci's numbers with this simple call
	(recurrent-sequence-2 1 1 1 1 max) )

(defun rational-approximation-sqrt2 (max)
 "Approximate square root of 2 with (P(n-1)+P(n-2))/P(n)"
	(butlast (maplist #'(lambda (l) (/ (+ (first l) (or (second l) 0)) (or (second l) 1))) (pell-sequence max))) )

(defun pell-primes (max)
	(do* ((i 0 (1+ i))
	      (result (list 1 0))
	      (indices nil)
	      (b0 0 b1)
	      (b1 1 b2)
	      (b2 (+ (* 2 b1) (* 1 b0)) (+ (* 2 b1) (* 1 b0))) )
	  	((> (length result) max) (values (nreverse result)(nreverse indices)))
      ; primep can be any function determining whether a number is prime, for example,
      ; https://rosettacode.org/wiki/Primality_by_Wilson%27s_theorem#Common_Lisp
	  (when (primep b2)
			(push b2 result)
			(push i indices) )))
