;;;using flet to define local functions and storing precalculated column widths in array
;;;verbose, but more readable and efficient than version 2

(defun floydtriangle (rows)
       (let (column-widths)
         (setf column-widths (make-array rows :initial-element nil))
           (flet (
             (lazycat (n)
              (/ (+ (expt n 2) n 2) 2))
             (width (v)
              (+ 1 (floor (log v 10)))))
            (dotimes (i rows)
             (setf (aref column-widths i)(width (+ i (lazycat (- rows 1))))))
            (dotimes (row rows)
             (dotimes (col (+ 1 row))
               (format t "~vd " (aref column-widths col)(+ col (lazycat row))))
             (format t "~%")))))
