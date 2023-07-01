(de brez (Img X Y DX DY)
   (let SX
      (cond
         ((=0 DX) 0)
         ((gt0 DX) 1)
         (T (setq DX (- DX)) -1) )
      (let SY
         (cond
            ((=0 DY) 0)
            ((gt0 DY) 1)
            (T (setq DY (- DY)) -1) )
         (if (>= DX DY)
            (let E (- (* 2 DY) DX)
               (do DX
                  (set (nth Img Y X) 1)
                  (when (ge0 E)
                     (inc 'Y SY)
                     (dec 'E (* 2 DX)) )
                  (inc 'X SX)
                  (inc 'E (* 2 DY)) ) )
            (let E (- (* 2 DX) DY)
               (do DY
                  (set (nth Img Y X) 1)
                  (when (ge0 E)
                     (inc 'X SX)
                     (dec 'E (* 2 DY)) )
                  (inc 'Y SY)
                  (inc 'E (* 2 DX)) ) ) ) ) ) )

(let Img (make (do 90 (link (need 120 0))))        # Create image 120 x 90
   (brez Img 10 10 100 30)                         # Draw five lines
   (brez Img 10 10 100 50)
   (brez Img 10 10 100 70)
   (brez Img 10 10 60 70)
   (brez Img 10 10 20 70)
   (out "img.pbm"                                  # Write to bitmap file
      (prinl "P1")
      (prinl 120 " " 90)
      (mapc prinl Img) ) )
