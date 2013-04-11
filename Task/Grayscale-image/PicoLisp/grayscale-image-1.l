# Convert color image (PPM) to greyscale image (PGM)
(de ppm->pgm (Ppm)
   (mapcar
      '((Y)
         (mapcar
            '((C)
               (/
                  (+
                     (* (car C) 2126)  # Red
                     (* (cadr C) 7152)  # Green
                     (* (caddr C) 722) )  # Blue
                  10000 ) )
            Y ) )
      Ppm ) )

# Convert greyscale image (PGM) to color image (PPM)
(de pgm->ppm (Pgm)
   (mapcar
      '((Y)
         (mapcar
            '((G) (list G G G))
            Y ) )
      Pgm ) )
