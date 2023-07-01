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

(de almost (N)
   (let (X 2  Y 0)
      (make
         (loop
            (when (and (nth (factor X) N) (not (cdr @)))
               (link X)
               (inc 'Y) )
            (T (= 10 Y) 'done)
            (inc 'X) ) ) ) )

(for I 5
   (println I '-> (almost I) ) )

(bye)
