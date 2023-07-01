(de insertAfter (Item Lst New)
   (when (member Item Lst)
      (con @ (cons New (cdr @))) )
   Lst )
