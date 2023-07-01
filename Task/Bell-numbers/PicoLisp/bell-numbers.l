(de bell (N)
   (make
      (setq L (link (list 1)))
      (do N
         (setq L
            (link
               (make
                  (setq A (link (last L)))
                  (for B L
                     (setq A (link (+ A B))) ) ) ) ) ) ) )
(setq L (bell 51))
(for N 15
   (tab (2 -2 -2) N ":" (get L N 1)) )
(prinl 50 ": " (get L 50 1))
(prinl)
(prinl "First ten rows:")
(for N 10
   (println (get L N)) )
