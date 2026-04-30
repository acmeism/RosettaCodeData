CL-USER> ;; create a 4-dimensional array
         (make-array '(5 4 3 2) :initial-element 0)
#4A((((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0)))
    (((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0)))
    (((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0)))
    (((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0)))
    (((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0))
     ((0 0) (0 0) (0 0))))
CL-USER> ;; bind it to a variable (in the REPL, '*' is the value of the last evaluated form)
         (defparameter arr *)
ARR
CL-USER> ;; query array rank (number of dimensions) and dimensions
         (array-rank arr)
4
CL-USER> (array-dimensions arr)
(5 4 3 2)
CL-USER> ;; access, set, and access again element
         (aref arr 3 2 1 1)
0
CL-USER> (setf (aref arr 3 2 1 1) 2)
2
CL-USER> (aref arr 3 2 1 1)
2
CL-USER> ;; arrays are stored row-major order and elements can be accessed (and set) that way
         ;; first let's get the row-major index
         (array-row-major-index arr 3 2 1 1)
87
CL-USER> (setf (row-major-aref arr 87) 3)
3
CL-USER> (aref arr 3 2 1 1)
3
CL-USER> ;; adjustable arrays can be reshaped
         (make-array '(3 3 3) :adjustable t :initial-element 0)
#3A(((0 0 0) (0 0 0) (0 0 0))
    ((0 0 0) (0 0 0) (0 0 0))
    ((0 0 0) (0 0 0) (0 0 0)))
CL-USER> (adjust-array * '(4 4 4) :initial-element 1)
#3A(((0 0 0 1) (0 0 0 1) (0 0 0 1) (1 1 1 1))
    ((0 0 0 1) (0 0 0 1) (0 0 0 1) (1 1 1 1))
    ((0 0 0 1) (0 0 0 1) (0 0 0 1) (1 1 1 1))
    ((1 1 1 1) (1 1 1 1) (1 1 1 1) (1 1 1 1)))
CL-USER> ;; some built-in limits for arrays (they seem to be memory bound):
         (list array-rank-limit array-dimension-limit array-total-size-limit)
(129 35184372088832 35184372088832)
