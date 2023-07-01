(de recursiveSearch (Val Lst Len)
   (unless (=0 Len)
      (let (N (inc (/ Len 2))  L (nth Lst N))
         (cond
            ((= Val (car L)) Val)
            ((> Val (car L))
               (recursiveSearch Val (cdr L) (- Len N)) )
            (T (recursiveSearch Val Lst (dec N))) ) ) ) )
