(scl 15)
(let (F 1  E 2.0  E0 0  N 2)
   (while (> E E0)
      (setq E0 E  F (* F N))
      (inc 'E (*/ 1.0 F))
      (inc 'N) )
   (prinl "e = " (format E *Scl)) )
