(de galtonBox (Pins Height)
   (let (Bins (need (inc (* 2 Pins)) 0)  X 0  Y 0)
      (until (= Height (apply max Bins))
         (call 'clear)
         (cond
            ((=0 Y) (setq X (inc Pins)  Y 1))
            ((> (inc 'Y) Pins)
               (inc (nth Bins X))
               (zero Y) ) )
         ((if (rand T) inc dec) 'X)
         (for Row Pins
            (for Col (+ Pins Row 1)
               (let D (dec (- Col (- Pins Row)))
                  (prin
                     (cond
                        ((and (= X Col) (= Y Row)) "o")
                        ((and (gt0 D) (bit? 1 D)) ".")
                        (T " ") ) ) ) )
            (prinl) )
         (prinl)
         (for H (range Height 1)
            (for B Bins
               (prin (if (>= B H) "o" " ")) )
            (prinl) )
         (wait 200) ) ) )
