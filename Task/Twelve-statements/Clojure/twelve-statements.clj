(use '[clojure.math.combinatorics]

(defn xor? [& args]
  (odd? (count (filter identity args))))

(defn twelve-statements []
  (for [[a b c d e f g h i j k l] (selections [true false] 12)
    :when (true? a)
    :when (if (= 3 (count (filter true? [g h i j k l]))) (true? b) (false? b))
    :when (if (= 2 (count (filter true? [b d f h j l]))) (true? c) (false? c))
    :when (if (or (false? e) (every? true? [e f g])) (true? d) (false? d))
    :when (if (every? false? [b c d]) (true? e) (false? e))
    :when (if (= 4 (count (filter true? [a c e g i k]))) (true? f) (false? f))
    :when (if (xor? (true? b) (true? c)) (true? g) (false? g))
    :when (if (or (false? g) (every? true? [e f g])) (true? h) (false? h))
    :when (if (= 3 (count (filter true? [a b c d e f]))) (true? i) (false? i))
    :when (if (every? true? [k l]) (true? j) (false? j))
    :when (if (= 1 (count (filter true? [g h i]))) (true? k) (false? k))
    :when (if (= 4 (count (filter true? [a b c d e f g h i j k]))) (true? l) (false? l))]
  [a b c d e f g h i j k l]))
