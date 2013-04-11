(de encode (Str)
   (pack
      (make
         (for (Lst (chop Str) Lst)
            (let (N 1  C)
               (while (= (setq C (pop 'Lst)) (car Lst))
                  (inc 'N) )
               (link N C) ) ) ) ) )

(de decode (Str)
   (pack
      (make
         (let N 0
            (for C (chop Str)
               (if (>= "9" C "0")
                  (setq N (+ (format C) (* 10 N)))
                  (do N (link C))
                  (zero N) ) ) ) ) ) )

(and
   (prinl "Data:    " "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW")
   (prinl "Encoded: " (encode @))
   (prinl "Decoded: " (decode @)) )
