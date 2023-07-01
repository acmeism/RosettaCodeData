(defun start ()
  (format t "Largest right-truncatable ~a~%" (max-right-truncatable))
  (format t "Largest left-truncatable  ~a~%" (max-left-truncatable)))

(defun max-right-truncatable ()
  (loop for el in (6-digits-R-truncatables)
        maximizing el into max
        finally (return max)))

(defun 6-digits-R-truncatables (&optional (lst '(2 3 5 7)) (n 5))
  (if (zerop n)
    lst
    (6-digits-R-truncatables (R-trunc lst) (- n 1))))

(defun R-trunc (lst)
  (remove-if (lambda (x) (not (primep x)))
	     (loop for el in lst
		   append (mapcar (lambda (x) (+ (* 10 el) x)) '(1 3 7 9)))))

(defun max-left-truncatable ()
  (loop for el in (6-digits-L-truncatables)
        maximizing el into max
        finally (return max)))

(defun 6-digits-L-truncatables (&optional (lst '(3 7)) (n 5))
  (if (zerop n)
    lst
    (6-digits-L-truncatables (L-trunc lst (- 6 n)) (- n 1))))

(defun L-trunc (lst n)
  (remove-if (lambda (x) (not (primep x)))
	     (loop for el in lst
		   append (mapcar (lambda (x) (+ (* (expt 10 n) x) el)) '(1 2 3 4 5 6 7 8 9)))))

(defun primep (n)
  (primep-aux n 2))

(defun primep-aux (n d)
  (cond ((> d (sqrt n)) t)
        ((zerop (rem n d)) nil)
        (t (primep-aux n (+ d 1)))))
