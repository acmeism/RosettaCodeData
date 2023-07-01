;;; balanced ternary
;;; represented as a list of 0, 1 or -1s, with least significant digit first

;;; convert ternary to integer
(defun bt-integer (b)
  (reduce (lambda (x y) (+ x (* 3 y))) b :from-end t :initial-value 0))

;;; convert integer to ternary
(defun integer-bt (n)
  (if (zerop n) nil
    (case (mod n 3)
      (0 (cons  0 (integer-bt (/ n 3))))
      (1 (cons  1 (integer-bt (floor n 3))))
      (2 (cons -1 (integer-bt (floor (1+ n) 3)))))))

;;; convert string to ternary
(defun string-bt (s)
  (loop with o = nil for c across s do
	  (setf o (cons (case c (#\+ 1) (#\- -1) (#\0 0)) o))
	  finally (return o)))

;;; convert ternary to string
(defun bt-string (bt)
  (if (not bt) "0"
    (let* ((l (length bt))
	   (s (make-array l :element-type 'character)))
      (mapc (lambda (b)
	      (setf (aref s (decf l))
		    (case b (-1 #\-) (0 #\0) (1 #\+))))
	    bt)
      s)))

;;; arithmetics
(defun bt-neg (a) (map 'list #'- a))
(defun bt-sub (a b) (bt-add a (bt-neg b)))

(let ((tbl #((0 -1) (1 -1) (-1 0) (0 0) (1 0) (-1 1) (0 1))))
  (defun bt-add-digits (a b c)
    (values-list (aref tbl (+ 3 a b c)))))

(defun bt-add (a b &optional (c 0))
  (if (not (and a b))
    (if (zerop c) (or a b)
      (bt-add (list c) (or a b)))
    (multiple-value-bind (d c)
      (bt-add-digits (if a (car a) 0) (if b (car b) 0) c)
      (let ((res (bt-add (cdr a) (cdr b) c)))
	;; trim leading zeros
	(if (or res (not (zerop d)))
	  (cons d res))))))

(defun bt-mul (a b)
  (if (not (and a b))
    nil
    (bt-add (case (car a)
	        (-1 (bt-neg b))
		( 0 nil)
		( 1 b))
	    (cons 0 (bt-mul (cdr a) b)))))

;;; division with quotient/remainder, for completeness
(defun bt-truncate (a b)
  (let ((n (- (length a) (length b)))
	(d (car (last b))))
    (if (minusp n)
      (values nil a)
      (labels ((recur (a b x)
	 (multiple-value-bind (quo rem)
	   (if (plusp x) (recur a (cons 0 b) (1- x))
	     (values nil a))

	   (loop with g = (car (last rem))
		 with quo = (cons 0 quo)
		 while (= (length rem) (length b)) do
		 (cond ((= g d) (setf rem (bt-sub rem b)
				      quo (bt-add '(1) quo)))
		       ((= g (- d)) (setf rem (bt-add rem b)
					  quo (bt-add '(-1) quo))))
		 (setf x (car (last rem)))
		 finally (return (values quo rem))))))

	(recur a b n)))))

;;; test case
(let* ((a (string-bt "+-0++0+"))
       (b (integer-bt -436))
       (c (string-bt "+-++-"))
       (d (bt-mul a (bt-sub b c))))
  (format t "a~5d~8t~a~%b~5d~8t~a~%c~5d~8t~a~%a × (b − c) = ~d ~a~%"
	  (bt-integer a) (bt-string a)
	  (bt-integer b) (bt-string b)
	  (bt-integer c) (bt-string c)
	  (bt-integer d) (bt-string d)))
