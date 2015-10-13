(defun dot-product (v1 v2)
  (setq res 0)
  (dotimes (i (length v1))
    (setq res (+ (* (elt v1 i) (elt v2 i) ) res) ))
  res)

(progn
  (insert (format "%d\n" (dot-product [1 2 3] [1 2 3]) ))
  (insert (format "%d\n" (dot-product '(1 2 3) '(1 2 3) ))))
