(let Pgm  # Create PGM of 384 x 288 pixels
   (make
      (for N 4
         (let L
            (make
               (for I (* N 8)
                  (let C (*/ (dec I) 255 (dec (* N 8)))
                     (unless (bit? 1 N)
                        (setq C (- 255 C)) )
                     (do (/ 48 N) (link C)) ) ) )
            (do 72 (link L)) ) ) )
   (out '(display)  # Pipe to ImageMagick
      (prinl "P5")  # NetPBM format
      (prinl (length (car Pgm)) " " (length Pgm))
      (prinl 255)
      (for Y Pgm (apply wr Y)) ) )
