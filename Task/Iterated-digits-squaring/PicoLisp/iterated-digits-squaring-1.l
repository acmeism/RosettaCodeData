(de *Idx1or89 (89 . 89) ((1 . 1)))

(de 1or89 (N)
   (let L (mapcar format (chop N))
      (if (lup *Idx1or89 (setq N (sum * L L)))
         (cdr @)
         (prog1
            (1or89 N)
            (idx '*Idx1or89 (cons N @) T) ) ) ) )
