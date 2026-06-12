(format t "~{~a ~}~%"
        (loop for a from 1 to 100 collect
              (loop for b from 1 to a
                    when (zerop (rem a b))
                    sum b)))
