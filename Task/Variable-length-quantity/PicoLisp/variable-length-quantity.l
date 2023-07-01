(de numToVlq (Num)
   (let Res (cons (& Num 127))
      (while (gt0 (setq Num (>> 7 Num)))
         (push 'Res (| 128 (& Num 127))) )
      Res ) )

(de vlqToNum (Vlq)
   (let Res 0
      (for N Vlq
         (setq Res (| (>> -7 Res) (& N 127))) ) ) )

(for Num (0 15 16 127 128 255 2097151 2097152)
   (let Vlq (numToVlq Num)
      (tab (12 12 12) Num (glue ":" (mapcar hex Vlq)) (vlqToNum Vlq)) ) )
