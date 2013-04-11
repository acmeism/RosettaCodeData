(de hailstone (N)
   (make
      (until (= 1 (link N))
         (setq N
            (if (bit? 1 N)
               (inc (* N 3))
               (/ N 2) ) ) ) ) )

(let L (hailstone 27)
   (println 27 (length L) (head 4 L) '- (tail 4 L)) )

(let N (maxi '((N) (length (hailstone N))) (range 1 100000))
   (println N (length (hailstone N))) )
