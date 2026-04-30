(defun compose (f g)
  `(lambda (x) (,f (,g x))))

(let ((func (compose '1+ '1+)))
  (funcall func 5)) ;=> 7
