(defun compose (f g)
  (eval `(lambda (x) (funcall ',f (funcall ',g x)))))
