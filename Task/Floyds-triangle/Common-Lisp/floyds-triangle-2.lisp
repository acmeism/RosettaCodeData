;;; more concise than version 1 but less efficient for a large triangle
;;;optional "base" parameter will allow use of any base from 2 to 36

(defun floydtriangle (rows &optional (base 10))
       (dotimes (row rows)
         (dotimes (column (+ 1 row))
           (format t "~v,vr " base (length (format nil "~vr" base (+ column (/ (+ (expt (- rows 1) 2) (- rows 1) 2) 2)))) (+ column (/ (+ (expt row 2) row 2) 2))))
         (format t "~%")))
