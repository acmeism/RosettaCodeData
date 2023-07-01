(defun dot-product (v1 v2)
  (let ((res 0))
    (dotimes (i (length v1))
      (setq res (+ (* (elt v1 i) (elt v2 i)) res)))
    res))

(dot-product [1 2 3] [1 2 3]) ;=> 14
(dot-product '(1 2 3) '(1 2 3)) ;=> 14
