(de alt (List)
   (if List (cons (car List) (alt (cddr List))) ()) )

(de merge (L1 L2)
   (cond
      ((not L2) L1)
      ((< (car L1) (car L2))
         (cons (car L1) (merge L2 (cdr L1))))
      (T (cons (car L2) (merge L1 (cdr L2)))) ) )

(de mergesort (List)
   (if (cdr List)
      (merge (mergesort (alt List)) (mergesort (alt (cdr List))))
      List) )

(mergesort (8 1 5 3 9 0 2 7 6 4))
