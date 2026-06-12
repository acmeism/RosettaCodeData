(de matchEbnf (Pat)
   (cond
      ((asoq Pat '((PLUS . +) (MINUS . -) (MULT . *) (DIV . /)))
         (let Op (cdr @)
            (when (= Op (car *Lst))
               (pop '*Lst)
               Op ) ) )
      ((== 'NUMBER Pat)
         (cond
            ((num? (car *Lst))
               (pop '*Lst)
               @ )
            ((and (= "-" (car *Lst)) (num? (cadr *Lst)))
               (setq *Lst (cddr *Lst))
               (- @) ) ) )
      ((get Pat 'ebnf) (parseLst @))
      ((atom Pat))
      (T
         (loop
            (T (matchEbnf (pop 'Pat)) @)
            (NIL Pat)
            (NIL (== '| (pop 'Pat)))
            (NIL Pat) ) ) ) )

(de parseLst (Pat)
   (let (P (pop 'Pat)  X (matchEbnf P))
      (loop
         (NIL Pat)
         (if (n== '* (cadr Pat))
            (if (matchEbnf (pop 'Pat))
               (setq X (list @ X))
               (throw) )
            (loop
               (NIL *Lst)
               (NIL (matchEbnf (car Pat)))
               (setq X (list @ X (or (matchEbnf P) (throw)))) )
            (setq Pat (cddr Pat)) ) )
      X ) )

(de parseEbnf (Str)
   (let *Lst (str Str "")
      (catch NIL
         (parseLst (get 'expr 'ebnf)) ) ) )
