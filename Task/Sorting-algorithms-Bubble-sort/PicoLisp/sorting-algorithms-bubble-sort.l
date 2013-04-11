(de bubbleSort (Lst)
   (use Chg
      (loop
         (off Chg)
         (for (L Lst (cdr L) (cdr L))
            (when (> (car L) (cadr L))
               (xchg L (cdr L))
               (on Chg) ) )
         (NIL Chg Lst) ) ) )
