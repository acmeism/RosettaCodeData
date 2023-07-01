# Create an empty image of 120 x 90 pixels
(setq *Ppm (make (do 90 (link (need 120)))))

# Fill an image with a given color
(de ppmFill (Ppm R G B)
   (for Y Ppm
      (map
         '((X) (set X (list R G B)))
         Y ) ) )

# Set pixel with a color
(de ppmSetPixel (Ppm X Y R G B)
   (set (nth Ppm Y X) (list R G B)) )

# Get the color of a pixel
(de ppmGetPixel (Ppm X Y)
   (get Ppm Y X) )
