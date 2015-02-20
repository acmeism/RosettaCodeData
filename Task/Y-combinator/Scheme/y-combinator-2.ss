(define Y
  (lambda (h)
    (lambda args (apply (h (Y h)) args))))
