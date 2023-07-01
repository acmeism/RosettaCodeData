(de 3not (A)
   (or (=0 A) (not A)) )

(de 3and (A B)
   (cond
      ((=T A) B)
      ((=0 A) (and B 0)) ) )

(de 3or (A B)
   (cond
      ((=T A) T)
      ((=0 A) (or (=T B) 0))
      (T B) ) )

(de 3impl (A B)
   (cond
      ((=T A) B)
      ((=0 A) (or (=T B) 0))
      (T T) ) )

(de 3equiv (A B)
   (cond
      ((=T A) B)
      ((=0 A) 0)
      (T (3not B)) ) )
