(de truthTable (Expr)
   (let Vars
      (uniq
         (make
            (setq Expr
               (recur (Expr)  # Convert infix to prefix notation
                  (cond
                     ((atom Expr) (link Expr))
                     ((== 'not (car Expr))
                        (list 'not (recurse (cadr Expr))) )
                     (T
                        (list
                           (cadr Expr)
                           (recurse (car Expr))
                           (recurse (caddr Expr)) ) ) ) ) ) ) )
      (for V Vars
         (prin (align -7 V)) )
      (prinl)
      (bind (mapcar cons Vars)
         (do (** 2 (length Vars))
            (for "V" Vars
               (space (if (print (val "V")) 6 4)) )
            (println (eval Expr))
            (find '(("V") (set "V" (not (val "V")))) Vars) ) ) ) )
