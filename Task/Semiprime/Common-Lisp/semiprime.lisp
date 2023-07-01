(defun semiprimep (n &optional (a 2))
  (cond ((> a (isqrt n)) nil)
        ((zerop (rem n a)) (and (primep a) (primep (/ n a))))
        (t (semiprimep n (+ a 1)))))

(defun primep (n &optional (a 2))
  (cond ((> a (isqrt n)) t)
        ((zerop (rem n a)) nil)
        (t (primep n (+ a 1)))))
