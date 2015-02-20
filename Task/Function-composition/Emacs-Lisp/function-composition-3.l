(eval-when-compile (require 'cl)) ;; for `lexical-let' macro
(defun compose (f g)
  (lexical-let ((f f)
                (g g))
    (lambda (x)
      (funcall f (funcall g x)))))

(let ((func (compose '1+ '1+)))
  (funcall func 5))
=>
7
