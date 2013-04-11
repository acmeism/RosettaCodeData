(defun maprange (a1 a2 b1 b2 s)
   (+ b1 (/ (* (- s a1) (- b2 b1)) (- a2 a1))))

(dotimes (i 10)
  (princ (maprange 0.0 10.0 -1.0 0.0 i))
  (terpri))
