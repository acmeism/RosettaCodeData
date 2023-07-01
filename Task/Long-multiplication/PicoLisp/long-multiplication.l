(de multi (A B)
   (setq A (format A) B (reverse (chop B)))
   (let Result 0
      (for (I . X) B
         (setq Result (+ Result (* (format X) A (** 10 (dec I)))))) ) )
