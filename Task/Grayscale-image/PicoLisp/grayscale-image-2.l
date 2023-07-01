# Write greyscale image (PGM) to file
(de pgmWrite (Pgm File)
   (out File
      (prinl "P5")
      (prinl (length (car Pgm)) " " (length Pgm))
      (prinl 255)
      (for Y Pgm (apply wr Y)) ) )

# Create an empty image of 120 x 90 pixels
(setq *Ppm (make (do 90 (link (need 120)))))

# Fill background with green color
(ppmFill *Ppm 0 255 0)

# Draw a diagonal line
(for I 80 (ppmSetPixel *Ppm I I 0 0 0))


# Convert to greyscale image (PGM)
(setq *Pgm (ppm->pgm *Ppm))

# Write greyscale image to .pgm file
(pgmWrite *Pgm "img.pgm")

# Convert to color image and write to .ppm file
(ppmWrite (pgm->ppm *Pgm) "img.ppm")
