(de *Colors  # Black Red Green Blue Magenta Cyan Yellow White
   ((0 0 0) (255 0 0) (0 255 0) (0 0 255)
      (255 0 255) (0 255   255) (255 255 0) (255 255 255) .) )

(let Ppm  # Create PPM of 384 x 288 pixels
   (make
      (for N 4
         (let L
            (make
               (do (/ 384 N)
                  (let C (pop *Colors)
                     (do N (link C)) ) ) )
            (do 72 (link L)) ) ) )
   (out '(display)  # Pipe to ImageMagick
      (prinl "P6")  # NetPBM format
      (prinl (length (car Ppm)) " " (length Ppm))
      (prinl 255)
      (for Y Ppm (for X Y (apply wr X))) ) )
