(DEFUN RANGE (X Y)
    (IF (<= X Y)
        (CONS X (RANGE (+ X 1) Y))))

(PRINT (MAPCAR FIBONACCI (RANGE 1 50)))
