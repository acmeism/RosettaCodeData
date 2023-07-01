# Create an empty image of 120 x 90 pixels
(setq *Ppm (make (do 90 (link (need 120)))))

# Fill background with green color
(ppmFill *Ppm 0 255 0)

# Draw a diagonal line
(for I 80 (ppmSetPixel *Ppm I I 0 0 0))

# Write to "img.jpg" through a pipe
(ppmWrite *Ppm '("convert" "-" "img.jpg"))
