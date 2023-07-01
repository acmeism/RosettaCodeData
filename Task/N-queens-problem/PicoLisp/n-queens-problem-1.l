(load "@lib/simul.l")  # for 'permute'

(de queens (N)
   (let (R (range 1 N)  Cnt 0)
      (for L (permute (range 1 N))
         (when
            (= N  # from the Python solution
               (length (uniq (mapcar + L R)))
               (length (uniq (mapcar - L R))) )
            (inc 'Cnt) ) )
      Cnt ) )
