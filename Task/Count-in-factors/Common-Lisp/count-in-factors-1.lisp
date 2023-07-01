(defparameter *primes*
  (make-array 10 :adjustable t :fill-pointer 0 :element-type 'integer))

(mapc #'(lambda (x) (vector-push x *primes*)) '(2 3 5 7))

(defun extend-primes (n)
  (let ((p (+ 2 (elt *primes* (1- (length *primes*))))))
    (loop for i = p then (+ 2 i)
	  while (<= (* i i) n) do
	  (if (primep i t) (vector-push-extend i *primes*)))))

(defun primep (n &optional skip)
  (if (not skip) (extend-primes n))
  (if (= n 1) nil
      (loop for p across *primes* while (<= (* p p) n)
	    never (zerop (mod n p)))))

(defun factors (n)
  (extend-primes n)
  (loop with res for x across *primes* while (> n (* x x)) do
	(loop while (zerop (rem n x)) do
	      (setf n (/ n x))
	      (push x res))
	finally (return (if (> n 1) (cons n res) res))))

(loop for n from 1 do
      (format t "~a: ~{~a~^ × ~}~%" n (reverse (factors n))))
