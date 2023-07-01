(de heapSort (A Cnt)
   (let Cnt (length A)
      (for (Start (/ Cnt 2) (gt0 Start) (dec Start))
         (siftDown A Start (inc Cnt)) )
      (for (End Cnt (> End 1) (dec End))
         (xchg (nth A End) A)
         (siftDown A 1 End) ) )
   A )

(de siftDown (A Start End)
   (use Child
      (for (Root Start  (> End (setq Child (* 2 Root))))
         (and
            (> End (inc Child))
            (> (get A (inc Child)) (get A Child))
            (inc 'Child) )
         (NIL (> (get A Child) (get A Root)))
         (xchg (nth A Root) (nth A Child))
         (setq Root Child) ) ) )
