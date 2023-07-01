(de insertAfter (Item Lst New)
   (if (index Item Lst)
      (conc (cut @ 'Lst) (cons New Lst))
      Lst ) )
