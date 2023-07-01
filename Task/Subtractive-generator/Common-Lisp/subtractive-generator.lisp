(defun sub-rand (state)
  (let ((x (last state)) (y (last state 25)))
    ;; I take "circular buffer" very seriously (until some guru
    ;; points out it's utterly wrong thing to do)
    (setf (cdr x) state)
    (lambda () (setf x (cdr x)
		     y (cdr y)
		     (car x) (mod (- (car x) (car y)) (expt 10 9))))))

;; returns an RNG with Bentley seeding
(defun bentley-clever (seed)
  (let ((s (list 1 seed))  f)
    (dotimes (i 53)
      (push (mod (- (cadr s) (car s)) (expt 10 9)) s))
    (setf f (sub-rand
	      (loop for i from 1 to 55 collect
		    (elt s (- 54 (mod (* 34 i) 55))))))
    (dotimes (x 165) (funcall f))
    f))

;; test it (output same as everyone else's)
(let ((f (bentley-clever 292929)))
  (dotimes (x 10) (format t "~a~%" (funcall f))))
