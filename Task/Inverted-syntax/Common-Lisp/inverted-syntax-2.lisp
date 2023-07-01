(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun unrev-syntax (form)
    (cond
      ((atom form) form) ;; atom: leave alone
      ((null (cdr form)) form) ;; one-element form: leave alone
      ((null (cddr form)) ;; two-element form: swap
       (destructuring-bind (arg oper) form
         `(,oper ,(unrev-syntax arg))))
      (t    ;; two or more args: swap last two, add others in reverse
       (destructuring-bind (arg1 oper &rest args) (reverse form)
        `(,oper ,(unrev-syntax arg1) ,@(mapcar #'unrev-syntax args)))))))

(defmacro rprogn (&body forms)
  `(progn ,@(mapcar #'unrev-syntax forms)))
