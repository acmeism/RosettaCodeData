(de consolidate (S)
   (when S
      (let R (cons (car S))
         (for X (consolidate (cdr S))
            (if (mmeq X (car R))
               (set R (uniq (conc X (car R))))
               (conc R (cons X)) ) )
         R ) ) )
