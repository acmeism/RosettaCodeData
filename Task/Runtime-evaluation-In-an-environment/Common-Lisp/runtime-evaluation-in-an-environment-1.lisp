(defun eval-with-x (program a b)
  (let ((at-a (eval `(let ((x ',a)) ,program)))
        (at-b (eval `(let ((x ',b)) ,program))))
    (- at-b at-a)))
