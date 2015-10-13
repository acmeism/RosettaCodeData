(defun or-f (&optional a b) (or a b));necessary for reduce, as 'or' is implemented as a macro

(defun prime-p (n)
  (cond ((< n  4) (>= n 2))
        ((zerop (rem n 2)) nil)
        (t (not (reduce #'or-f (mapcar (lambda (x) (zerop (rem n x))) (loop for i from 3 to (sqrt n) collect i)))))))

(defun mersenne-p (p)
  (or (= p 2)
      (let ((mp (- 1 (expt 2 p))))
        (do ((n 3) (s 4))
          ((> n p) (zerop s))
          (incf n)
          (setf s (rem (- (* s s) 2) mp))))))

(princ (remove-if-not #'mersenne-p (remove-if-not #'prime-p (loop for i to 5000 collect i))))
