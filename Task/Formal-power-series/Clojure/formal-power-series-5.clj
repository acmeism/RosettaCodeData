(def nfacts (iterate (fn [[f n]] [(* f n) (inc n)]) [1 1]))
(def facts (map first nfacts))

(def sin (map / (cycle [0  1  0 -1]) facts))
(def cos (map / (cycle [1  0 -1  0]) facts))

(println (take 10 sin))
; (0 1 0 -1/6 0 1/120 0 -1/5040 0 1/362880)

(println (take 10 (integrate cos)))
; (0 1 0 -1/6 0 1/120 0 -1/5040 0 1/362880)

(println (take 20 (ps+ (ps* sin sin) (ps* cos cos))))
; (1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
