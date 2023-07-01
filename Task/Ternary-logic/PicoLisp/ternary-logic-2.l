(for X '(T 0 NIL)
   (println 'not X '-> (3not X)) )

(for Fun '((and . 3and) (or . 3or) (implies . 3impl) (equivalent . 3equiv))
   (for X '(T 0 NIL)
      (for Y '(T 0 NIL)
         (println X (car Fun) Y '-> ((cdr Fun) X Y)) ) ) )
