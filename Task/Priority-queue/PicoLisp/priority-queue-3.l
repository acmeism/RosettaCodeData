(de heap-first (H)  (car H))

(de heap-merge (H1 H2)
   (cond
      ((= H1 NIL)  H2)
      ((= H2 NIL)  H1)
      ((< (car H1) (car H2))
         (cons (car H1) (cons H2 (cdr H1))))
      (T
         (cons (car H2) (cons H1 (cdr H2))))))

(de heap-insert (Item Heap)
   (heap-merge (list Item) Heap))

(de "merge-pairs" (H)
   (if (= (cdr H) NIL)
      (car H)   # also handles NIL (H = NIL -> NIL)
      (heap-merge
         (heap-merge (car H) (cadr H))
         ("merge-pairs" (cddr H)))))

(de heap-rest (H)
   ("merge-pairs" (cdr H)))
