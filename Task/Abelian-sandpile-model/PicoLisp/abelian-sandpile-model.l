(load "@lib/simul.l")
(symbols 'simul 'pico)
(de sandpile (A B)
   (let
      (Grid (grid A A)
         Size (/ (inc A) 2)
         Center (get Grid Size Size)
         Done T )
      (for G Grid
         (for This G
            (=: V 0) ) )
      (with Center
         (=: V B)
         (while Done
            (off Done)
            (for G Grid
               (for This G
                  (when (>= (: V) 4)
                     (=: V (- (: V) 4))
                     (on Done)
                     (mapc
                        '((Dir)
                           (with (Dir This) (=: V (inc (: V)))) )
                        '(north south west east) ) ) ) ) ) )
      (disp Grid 0
         '((This) (if (: V) (pack " " @ " ") "   ")) ) ) )
(sandpile 10 64)
