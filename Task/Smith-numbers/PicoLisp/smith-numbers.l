(de factor (N)
   (make
      (let (D 2  L (1 2 2 . (4 2 4 2 4 6 2 6 .))  M (sqrt N))
         (while (>= M D)
            (if (=0 (% N D))
               (setq M (sqrt (setq N (/ N (link D)))))
               (inc 'D (pop 'L)) ) )
         (link N) ) ) )
(de sumdigits (N)
   (sum format (chop N)) )
(de smith (X)
   (make
      (for N X
         (let R (factor N)
            (and
               (cdr R)
               (= (sum sumdigits R) (sumdigits N))
               (link N) ) ) ) ) )
(let L (smith 10000)
   (println 'first-10 (head 10 L))
   (println 'last-10 (tail 10 L))
   (println 'all (length L)) )
