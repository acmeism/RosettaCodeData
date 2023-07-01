(defun histo ()
  (let ((scoring (vector 0 1 3))
        (histo (list (vector 0 0 0 0 0 0 0 0 0 0) (vector 0 0 0 0 0 0 0 0 0 0)
                     (vector 0 0 0 0 0 0 0 0 0 0) (vector 0 0 0 0 0 0 0 0 0 0)))
        (team-combs (vector '(0 1) '(0 2) '(0 3) '(1 2) '(1 3) '(2 3)))
        (single-tupel)
        (sum))
       ; six nested dotimes produces the tupels of the cartesian product of
       ; six lists like '(0 1 2), but without to store all tuples in a list
       (dotimes (x0 3) (dotimes (x1 3) (dotimes (x2 3)
       (dotimes (x3 3) (dotimes (x4 3) (dotimes (x5 3)
           (setf single-tupel (vector x0 x1 x2 x3 x4 x5))
           (setf sum (vector 0 0 0 0))
           (dotimes (i (length single-tupel))
               (setf (elt sum (first (elt team-combs i)))
                     (+ (elt sum (first (elt team-combs i)))
                        (elt scoring (elt single-tupel i))))

               (setf (elt sum (second (elt team-combs i)))
                     (+ (elt sum (second (elt team-combs i)))
                        (elt scoring (- 2 (elt single-tupel i))))))

           (dotimes (i (length (sort sum #'<)))
               (setf (elt (nth i histo) (elt sum i))
                     (1+ (elt (nth i histo) (elt sum i)))))
       ))))))
       (reverse histo)))

; friendly output
(dolist (el (histo))
    (dotimes (i (length el))
        (format t "~3D " (aref el i)))
    (format t "~%"))
