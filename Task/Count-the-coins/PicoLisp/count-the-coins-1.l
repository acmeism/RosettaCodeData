(de coins (Sum Coins)
   (let (Buf (mapcar '((N) (cons 1 (need (dec N) 0))) Coins)  Prev)
      (do Sum
         (zero Prev)
         (for L Buf
            (inc (rot L) Prev)
            (setq Prev (car L)) ) )
      Prev ) )
