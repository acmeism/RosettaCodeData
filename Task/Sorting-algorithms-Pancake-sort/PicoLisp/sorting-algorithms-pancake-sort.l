(de pancake (Lst)
   (prog1 (flip Lst (index (apply max Lst) Lst))
      (for (L @  (cdr (setq Lst (cdr L)))  (cdr L))
         (con L (flip Lst (index (apply max Lst) Lst))) ) ) )
