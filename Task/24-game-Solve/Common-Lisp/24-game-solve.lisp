(defconstant +ops+ '(* / + -))

(defun digits ()
  (sort (loop repeat 4 collect (1+ (random 9))) #'<))

(defun expr-value (expr)
  (eval expr))

(defun divides-by-zero-p (expr)
  (when (consp expr)
    (destructuring-bind (op &rest args) expr
      (or (divides-by-zero-p (car args))
          (and (eq op '/)
               (or (and (= 1 (length args))
                        (zerop (expr-value (car args))))
                   (some (lambda (arg)
                           (or (divides-by-zero-p arg)
                               (zerop (expr-value arg))))
                         (cdr args))))))))

(defun solvable-p (digits &optional expr)
  (unless (divides-by-zero-p expr)
    (if digits
        (destructuring-bind (next &rest rest) digits
          (if expr
              (some (lambda (op)
                      (solvable-p rest (cons op (list next expr))))
                    +ops+)
            (solvable-p rest (list (car +ops+) next))))
      (when (and expr
                 (eql 24 (expr-value expr)))
        (merge-exprs expr)))))

(defun merge-exprs (expr)
  (if (atom expr)
      expr
    (destructuring-bind (op &rest args) expr
      (if (and (member op '(* +))
               (= 1 (length args)))
          (car args)
        (cons op
              (case op
                ((* +)
                 (loop for arg in args
                       for merged = (merge-exprs arg)
                       when (and (consp merged)
                                 (eq op (car merged)))
                       append (cdr merged)
                       else collect merged))
                (t (mapcar #'merge-exprs args))))))))

(defun solve-24-game (digits)
  "Generate a lisp form using the operators in +ops+ and the given
digits which evaluates to 24.  The first form found is returned, or
NIL if there is no solution."
  (solvable-p digits))
