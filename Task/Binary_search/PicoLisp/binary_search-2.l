(de iterativeSearch (Val Lst Len)
   (use (N L)
      (loop
         (T (=0 Len))
         (setq
            N (inc (/ Len 2))
            L (nth Lst N) )
         (T (= Val (car L)) Val)
         (if (> Val (car L))
            (setq Lst (cdr L)  Len (- Len N))
            (setq Len (dec N)) ) ) ) )
