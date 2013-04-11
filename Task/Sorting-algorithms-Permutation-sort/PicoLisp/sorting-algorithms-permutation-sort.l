(de permutationSort (Lst)
   (let L Lst
      (recur (L)  # Permute
         (if (cdr L)
            (do (length L)
               (T (recurse (cdr L)) Lst)
               (rot L)
               NIL )
            (apply <= Lst) ) ) ) )
