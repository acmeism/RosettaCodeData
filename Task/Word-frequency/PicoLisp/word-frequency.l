(setq *Delim " ^I^J^M-_.,\"'*[]?!&@#$%^\(\):;")
(setq *Skip (chop *Delim))

(de word+ NIL
   (prog1
      (lowc (till *Delim T))
      (while (member (peek) *Skip) (char)) ) )

(off B)
(in "135-0.txt"
   (until (eof)
      (let W (word+)
         (if (idx 'B W T) (inc (car @)) (set W 1)) ) ) )
(for L (head 10 (flip (by val sort (idx 'B))))
   (println L (val L)) )
