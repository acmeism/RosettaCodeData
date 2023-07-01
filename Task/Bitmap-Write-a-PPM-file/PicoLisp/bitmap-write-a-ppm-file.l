(de ppmWrite (Ppm File)
   (out File
      (prinl "P6")
      (prinl (length (car Ppm)) " " (length Ppm))
      (prinl 255)
      (for Y Ppm (for X Y (apply wr X))) ) )
