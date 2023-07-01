(load "@lib/simul.l")

(de brownianTree (File Size Cnt)
   (let Img (grid Size Size)
      (put Img (/ Size 2) (/ Size 2) 'pix T)
      (use (P Q)
         (do Cnt
            (setq P (get Img (rand 1 Size) (rand 1 Size)))
            (loop
               (setq Q ((if2 (rand T) (rand T) north east south west) P))
               (T (; Q pix) (put P 'pix T))
               (setq P (or Q (get Img (rand 1 Size) (rand 1 Size)))) ) ) )
      (out "img.pbm"
         (prinl "P1")
         (prinl Size " " Size)
         (for L Img
            (for This L
               (prin (if (: pix) 1 0)) )
            (prinl) ) ) ) )
