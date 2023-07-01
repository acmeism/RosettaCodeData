(load "@lib/simul.l")

(de reversalGame ()
   (let (Lst (shuffle (range 1 9))  Cnt 0)
      (while (apply < Lst)
         (setq Lst (shuffle Lst)) )
      (loop
         (printsp Lst)
         (T (apply < Lst) Cnt)
         (NIL (num? (read)))
         (setq Lst (flip Lst @))
         (inc 'Cnt) ) ) )
