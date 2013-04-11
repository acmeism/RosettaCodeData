(defun nest (l)
  (if (cdr l)
    `(,@(car l) ,(nest (cdr l)))
    (car l)))

(defun desugar-listc-form (form)
  (if (string= (car form) 'for)
    `(iter ,form)
    form))

(defmacro listc (expr &body (form . forms) &aux (outer (gensym)))
  (nest
    `((iter ,outer ,form)
      ,@(mapcar #'desugar-listc-form forms)
      (in ,outer (collect ,expr)))))
