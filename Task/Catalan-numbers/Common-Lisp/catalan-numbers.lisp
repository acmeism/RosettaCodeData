(defun catalan1 (n)
  ;; factorial. CLISP actually has "!" defined for this
  (labels ((! (x) (if (zerop x) 1 (* x (! (1- x))))))
    (/ (! (* 2 n)) (! (1+ n)) (! n))))

;; cache
(defparameter *catalans* (make-array 5
				     :fill-pointer 0
				     :adjustable t
				     :element-type 'integer))
(defun catalan2 (n)
    (if (zerop n) 1
    ;; check cache
    (if (< n (length *catalans*)) (aref *catalans* n)
      (loop with c = 0 for i from 0 to (1- n) collect
	    (incf c (* (catalan2 i) (catalan2 (- n 1 i))))
	    ;; lower values always get calculated first, so
	    ;; vector-push-extend is safe
	    finally (progn (vector-push-extend c *catalans*) (return c))))))

(defun catalan3 (n)
  (if (zerop n) 1 (/ (* 2 (+ n n -1) (catalan3 (1- n))) (1+ n))))

;;; test all three methods
(loop for f in (list #'catalan1 #'catalan2 #'catalan3)
      for i from 1 to 3 do
      (format t "~%Method ~d:~%" i)
      (dotimes (i 16) (format t "C(~2d) = ~d~%" i (funcall f i))))
