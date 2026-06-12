(format t "~{~a ~}~%"
        (loop for a from 1 to 100 collect
              (loop with z = 1 for b from 1 to a
                    when (zerop (rem a b)) do (setf z (* z b))
                    finally (return z))))
