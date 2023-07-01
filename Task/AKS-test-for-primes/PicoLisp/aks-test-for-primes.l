(de pascal (N)
   (let D 1
      (make
         (for X (inc N)
            (link D)
            (setq D
               (*/ D (- (inc N) X) (- X)) ) ) ) ) )

(for (X 0 (> 10 X) (inc X))
   (println X '-> (pascal X) ) )

(println
   (filter
      '((X)
         (fully
            '((Y) (=0 (% Y X)))
            (cdr (head -1 (pascal X))) ) )
      (range 2 50) ) )

(bye)
