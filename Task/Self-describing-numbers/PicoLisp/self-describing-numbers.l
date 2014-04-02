(de selfDescribing (N)
   (fully '((D I) (= D (cnt = N (circ I))))
      (setq N (mapcar format (chop N)))
      (range 0 (length N)) ) )
