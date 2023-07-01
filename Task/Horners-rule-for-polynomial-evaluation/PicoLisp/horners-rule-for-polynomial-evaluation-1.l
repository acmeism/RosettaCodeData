(de horner (Coeffs X)
   (let Res 0
      (for C (reverse Coeffs)
         (setq Res (+ C (* X Res))) ) ) )
