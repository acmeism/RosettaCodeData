(defun freeze (_fvars_ _lambda-expr_)
  (freeze-vars
    (mapc cons _fvars_ (mapc eval _fvars_))
    (cadr _lambda-expr_)
    (cddr _lambda-expr_)))

(defun freeze-vars (bindings lvars lbody)
  (list 'lambda lvars
        (list (cons 'lambda (cons bindings lbody)))))
