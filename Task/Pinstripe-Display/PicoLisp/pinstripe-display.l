(let Pbm  # Create PBM of 384 x 288 pixels
   (make
      (for N 4
         (let
            (C 0
               L (make
                  (do (/ 384 N)
                     (do N (link C))
                     (setq C (x| 1 C)) ) ) )
            (do 72 (link L)) ) ) )
   (out '(display)  # Pipe to ImageMagick
      (prinl "P1")
      (prinl (length (car Pbm)) " " (length Pbm))
      (mapc prinl Pbm) ) )
