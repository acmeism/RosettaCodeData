(de deepCopy (X)
   (let Mark NIL
      (recur (X)
         (cond
            ((atom X) X)
            ((asoq X Mark) (cdr @))
            (T
               (prog1 (cons)
                  (push 'Mark (cons X @))
                  (set @ (recurse (car X)))
                  (con @ (recurse (cdr X))) ) ) ) ) ) )
