;; lexical-binding: t
(defun compose (f g)
  (lambda (x)
    (funcall f (funcall g x))))

(let ((func (compose '1+ '1+)))
  (funcall func 5)) ;=> 7
