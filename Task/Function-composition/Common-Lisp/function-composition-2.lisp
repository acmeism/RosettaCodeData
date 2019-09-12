>(defun compose (f g) (lambda (x) (funcall f (funcall g x))))
COMPOSE
>(let ((sin-asin (compose #'sin #'asin)))
   (funcall sin-asin 0.5))
0.5
