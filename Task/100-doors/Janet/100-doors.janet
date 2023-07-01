(def doors (seq [_ :range [0 100]] false))

(loop [pass :range [0 100]
       door :range [pass 100 (inc pass)]]
  (put doors door (not (doors door))))

(print "open doors: " ;(seq [i :range [0 100] :when (doors i)] (string (inc i) " ")))
