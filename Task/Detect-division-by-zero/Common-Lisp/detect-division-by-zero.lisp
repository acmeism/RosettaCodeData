(handler-case (/ x y)
  (division-by-zero () (format t "division by zero caught!~%")))
