;; 256 is heavy overkill, but hey, we memoized
(defparameter *thiele-length* 256)
(defparameter *rho-cache* (make-hash-table :test #'equal))

(defmacro make-thele-func (f name xx0 xx1)
  (let ((xv (gensym)) (yv (gensym))
	(x0 (gensym)) (x1 (gensym)))
    `(let* ((,xv (make-array (1+ *thiele-length*)))
	    (,yv (make-array (1+ *thiele-length*)))
	    (,x0 ,xx0)
	    (,x1 ,xx1))
       (loop for i to *thiele-length* with x do
	     (setf x (+ ,x0 (* (/ (- ,x1 ,x0) *thiele-length*) i))
		   (aref ,yv i) x
		   (aref ,xv i) (funcall ,f x)))
       (defun ,name (x) (thiele x ,yv ,xv, 0)))))

(defun rho (yv xv n i)
  (let (hit (key (list yv xv n i)))
    (if (setf hit (gethash key *rho-cache*))
      hit
      (setf (gethash key *rho-cache*)
	    (cond ((zerop n) (aref yv i))
		  ((minusp n) 0)
		  (t (+ (rho yv xv (- n 2) (1+ i))
			(/  (- (aref xv i)
			       (aref xv (+ i n)))
			    (- (rho yv xv (1- n) i)
			       (rho yv xv (1- n) (1+ i)))))))))))

(defun thiele (x yv xv n)
  (if (= n *thiele-length*)
    1
    (+ (- (rho yv xv n 1) (rho yv xv (- n 2) 1))
       (/ (- x (aref xv (1+ n)))
	  (thiele x yv xv (1+ n))))))

(make-thele-func #'sin inv-sin 0 (/ pi 2))
(make-thele-func #'cos inv-cos 0 (/ pi 2))
(make-thele-func #'tan inv-tan 0 (/ pi 2.1)) ; tan(pi/2) is INF

(format t "~f~%" (* 6 (inv-sin .5)))
(format t "~f~%" (* 3 (inv-cos .5)))
(format t "~f~%" (* 4 (inv-tan 1)))
