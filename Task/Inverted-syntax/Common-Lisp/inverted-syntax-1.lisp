(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun unrev-syntax (form)
    (cond
      ((atom form) form)
      ((null (cddr form)) form)
      (t (destructuring-bind (oper &rest args) (reverse form)
           `(,oper ,@(mapcar #'unrev-syntax args)))))))

(defmacro rprogn (&body forms)
  `(progn ,@(mapcar #'unrev-syntax forms)))
