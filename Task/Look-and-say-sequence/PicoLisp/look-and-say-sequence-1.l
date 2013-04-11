(de las (Lst)
   (make
      (while Lst
         (let (N 1  C)
            (while (= (setq C (pop 'Lst)) (car Lst))
               (inc 'N) )
            (link N C) ) ) ) )
