(de ast (Str)
   (let *L (str Str "")
      (aggregate) ) )

(de aggregate ()
   (let X (product)
      (while (member (car *L) '("+" "-"))
         (setq X (list (intern (pop '*L)) X (product))) )
      X ) )

(de product ()
   (let X (term)
      (while (member (car *L) '("*" "/"))
         (setq X (list (intern (pop '*L)) X (term))) )
      X ) )

(de term ()
   (let X (pop '*L)
      (cond
         ((num? X) X)
         ((= "+" X) (term))
         ((= "-" X) (list '- (term)))
         ((= "(" X) (prog1 (aggregate) (pop '*L)))) ) ) )
