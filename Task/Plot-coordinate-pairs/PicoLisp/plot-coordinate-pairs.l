(load "@lib/ps.l")

(scl 1)

(de plot (PsFile DX DY Lst)
   (let (SX (length Lst)  SY (apply max Lst)  N 0 Val)
      (out PsFile
         (psHead (+ DX 20) (+ DY 40))
         (font (9 . "Helvetica"))
         (if (or (=0 SX) (=0 SY))
            (window 60 12 DX DY
               (font 24 ,"Not enough Data") )
            (setq Lst  # Build coordinates
               (let X -1
                  (mapcar
                     '((Y)
                        (cons
                           (*/ (inc 'X) DX SX)
                           (- DY (*/ Y DY SY)) ) )
                     Lst ) ) )
            (color 55 95 55  # Background color
               (let (X (+ DX 40) Y (+ DY 40))
                  (poly T  0 0  X 0  X Y  0 Y  0 0) ) )
            (window 20 20 DX DY  # Plot coordinates
               (poly NIL 0 0  0 DY  (- DX 20) DY)
               (color 76 24 24
                  (poly NIL (caar Lst) (cdar Lst) (cdr Lst)) ) )
            (window 4 4 60 12 (ps (format SY *Scl)))
            (for X SX
               (window (+ 6 (*/ (dec X) DX SX)) (+ 24 DY) 30 12
                  (ps (format (dec X)) 0) ) ) )
         (page) ) ) )

(plot "plot.ps" 300 200 (2.7 2.8 31.4 38.1 58.0 76.2 100.5 130.0 149.3 180.0))
(call 'display "plot.ps")
