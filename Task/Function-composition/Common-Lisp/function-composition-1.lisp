(defun compose (f g) (lambda (x) (funcall f (funcall g x))))
