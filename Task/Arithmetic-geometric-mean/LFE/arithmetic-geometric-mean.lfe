(defun agm (a g)
  (agm a g 1.0e-15))

(defun agm (a g tol)
  (if (=< (- a g) tol)
    a
    (agm (next-a a g)
         (next-g a g)
         tol)))

(defun next-a (a g)
  (/ (+ a g) 2))

(defun next-g (a g)
  (math:sqrt (* a g)))
