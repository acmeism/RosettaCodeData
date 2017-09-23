(defn triples [n]
  (list-comp (, a b c) [a (range 1 (inc n))
                        b (range a (inc n))
                        c (range b (inc n))]
             (= (pow c 2)
                (+ (pow a 2)
                   (pow b 2)))))

(print (triples 15))
; [(3, 4, 5), (5, 12, 13), (6, 8, 10), (9, 12, 15)]
