(let ((x 11) (y 22))
  ;; This is an error!  Inside the eval, x and y are unbound!
  (format t "~%x + y = ~a" (eval '(+ x y))))
