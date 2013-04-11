(defun zigzag (n)
  (flet ((move (i j)
           (if (< j (1- n))
               (values (max 0 (1- i)) (1+ j))
               (values (1+ i) j))))
    (loop with a = (make-array (list n n) :element-type 'integer)
          with x = 0
          with y = 0
          for v from 0 below (* n n)
          do (setf (aref a x y) v)
             (if (evenp (+ x y))
                 (setf (values x y) (move x y))
                 (setf (values y x) (move y x)))
          finally (return a))))
