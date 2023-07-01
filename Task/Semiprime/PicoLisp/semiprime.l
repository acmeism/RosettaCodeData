(de factor (N)
   (make
      (let
         (D 2
            L (1 2 2 . (4 2 4 2 4 6 2 6 .))
            M (sqrt N) )
         (while (>= M D)
            (if (=0 (% N D))
               (setq M
                  (sqrt (setq N (/ N (link D)))) )
               (inc 'D (pop 'L)) ) )
         (link N) ) ) )

(println
   (filter
      '((X)
         (let L (factor X)
            (and (cdr L) (not (cddr L))) ) )
      (conc (range 1 100) (range 1675 1680)) ) )

(bye)
