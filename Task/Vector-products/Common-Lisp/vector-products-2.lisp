(defun cross (a b)
  (when (and (equal (length a) 3) (equal (length b) 3))
      (vector
       (- (* (elt a 1) (elt b 2)) (* (elt a 2) (elt b 1)))
       (- (* (elt a 2) (elt b 0)) (* (elt a 0) (elt b 2)))
       (- (* (elt a 0) (elt b 1)) (* (elt a 1) (elt b 0))))))

(defun dot (a b)
  (when (equal (length a) (length b))
      (loop for ai across a for bi across b sum (* ai bi))))

(defun scalar-triple (a b c)
  (dot a (cross b c)))

(defun vector-triple (a b c)
  (cross a (cross b c)))

(defun task (a b c)
  (values (dot a b)
          (cross a b)
          (scalar-triple a b c)
          (vector-triple a b c)))
