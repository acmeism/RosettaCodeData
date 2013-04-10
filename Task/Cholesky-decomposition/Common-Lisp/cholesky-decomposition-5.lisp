;; example 1
CL-USER> (setf a '((25 15 -5) (15 18 0) (-5 0 11)))
((25 15 -5) (15 18 0) (-5 0 11))
CL-USER> (cholesky a)
((5 0 0) (3 3 0) (-1 1 3))
CL-USER> (format t "~{~{~5d~}~%~}" (cholesky a))
    5    0    0
    3    3    0
   -1    1    3
NIL
