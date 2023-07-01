(defparameter *mm* (make-hash-table :test #'equal))

;;; generic memoization macro
(defmacro defun-memoize (f (&rest args) &body body)
  (defmacro hash () `(gethash (cons ',f (list ,@args)) *mm*))
  (let ((h (gensym)))
    `(defun ,f (,@args)
       (let ((,h (hash)))
	 (if ,h ,h
	   (setf (hash) (progn ,@body)))))))

;;; def q
(defun-memoize q (n)
  (if (<= n 2) 1
    (+ (q (- n (q (- n 1))))
       (q (- n (q (- n 2)))))))

;;; test
(format t "First of Q: ~a~%Q(1000): ~a~%Bumps up to 100000: ~a~%"
	(loop for i from 1 to 10 collect (q i))
	(q 1000)
	(loop with c = 0 with last-q = (q 1)
	      for i from 2 to 100000
	      do (let ((next-q (q i)))
		   (if (< next-q last-q) (incf c))
		   (setf last-q next-q))
	      finally (return c)))
