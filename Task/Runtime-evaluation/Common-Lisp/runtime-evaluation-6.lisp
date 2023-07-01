(let ((x 11) (y 22))
  (format t "~%x + y = ~a" (eval `(+ ,x ,y))))
