(load "@lib/simul.l")

(de riffle (Lst)
   (let N (/ (setq @@ (length Lst)) 2)
      (conc
         (mapcan list (head N Lst) (tail (- N) Lst))
         (and (bit? 1 @@) (tail 1 Lst)) ) ) )
(de overhand (Lst)
   (let N (/ (* (length Lst) 20) 100)
      (make
         (while (flip (cut N 'Lst))
            (for I @
               (yoke I) ) ) ) ) )

(println 'riffle (riffle (range 1 19)) )
(println 'overhand (overhand (range 1 19)) )
(println 'shuffle (shuffle (range 1 19)) )
