(de numbers NIL
   (co 'numbers
      (let N 7
         (for P N
            (for S N
               (for F N
                  (yield (list P S F)) ) ) ) ) ) )
(de departments NIL
   (use (L)
      (while (setq L (numbers))
         (or
            (bit? 1 (car L))
            (= (car L) (cadr L))
            (= (car L) (caddr L))
            (= (cadr L) (caddr L))
            (<> 12 (apply + L))
            (println L) ) ) ) )
(departments)
