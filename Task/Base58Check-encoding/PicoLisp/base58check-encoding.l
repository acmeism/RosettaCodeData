(setq *B58Alpha
   (chop "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz") )
(de b58 (S)
   (let N 0
      (pack
         (make
            (if (pre? "0x" S)
               (setq N (hex (cddr (chop S))))
               (setq N (format S)) )
            (while (gt0 N)
               (yoke (get *B58Alpha (inc (% N 58))))
               (setq N (/ N 58)) ) ) ) ) )
(println (b58 "25420294593250030202636073700053352635053786165627414518"))
(println (b58 "0x626262"))
(println (b58 "0x636363"))
