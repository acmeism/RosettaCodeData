(def funcs (map #(fn [] (* % %)) (range 11)))
(printf "%d\n%d\n" ((nth funcs 3)) ((nth funcs 4)))
