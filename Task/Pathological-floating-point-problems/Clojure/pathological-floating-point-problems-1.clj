(def converge-to-six ((fn task1 [a b] (lazy-seq (cons a (task1 b (+ (- 111 (/ 1130 b)) (/ 3000 (* b a))))))) 2 -4))
(def values [3 4 5 6 7 8 20 30 50 100])
; print decimal values:
(pprint (sort (zipmap values (map double (map #(nth converge-to-six (dec %)) values)))))
; print rational values:
(pprint (sort (zipmap values (map #(nth converge-to-six (dec %)) values))))
