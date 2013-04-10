(load "@lib/simul.l")

(de life (DX DY . Init)
   (let Grid (grid DX DY)
      (for This Init
         (=: life T) )
      (loop
         (disp Grid NIL
            '((This) (if (: life) "X " "  ")) )
         (wait 1000)
         (for Col Grid
            (for This Col
               (let N  # Count neighbors
                  (cnt
                     '((Dir) (get (Dir This) 'life))
                     (quote
                        west east south north
                        ((X) (south (west X)))
                        ((X) (north (west X)))
                        ((X) (south (east X)))
                        ((X) (north (east X))) ) )
                  (=: next  # Next generation
                     (if (: life)
                        (>= 3 N 2)
                        (= N 3) ) ) ) ) )
         (for Col Grid  # Update
            (for This Col
               (=: life (: next)) ) ) ) ) )

(life 5 5  b3 c3 d3)
