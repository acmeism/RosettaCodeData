(seed (in "/dev/urandom" (rd 8)))
(de swapL (Lst X Y)
   (let L (nth Lst Y)
      (swap
         L
         (swap (nth Lst X) (car L)) ) ) )
(de partition (Lst L R P)
   (let V (get Lst P)
      (swapL Lst R P)
      (for I (range L R)
         (and
            (> V (get Lst I))
            (swapL Lst L I)
            (inc 'L) ) )
      (swapL Lst L R)
      L ) )
(de quick (Lst N L R)
   (default L (inc N)  R (length Lst))
   (if (= L R)
      (get Lst L)
      (let P (partition Lst L R (rand L R))
         (cond
            ((= N P) (get Lst N))
            ((> P N) (quick Lst N L P))
            (T (quick Lst N P R)) ) ) ) )
(let Lst (9 8 7 6 5 0 1 2 3 4)
   (println
      (mapcar
         '((N) (quick Lst N))
         (range 0 9) ) ) )
