(ns left-factorial
  (:gen-class))

(defn left-factorial [n]
  " Compute by updating the state [fact summ] for each k, where k equals 1 to n
    Update is next state is [k*fact (summ+k)"
  (second
    (reduce (fn [[fact summ] k]
              [(*' fact k) (+ summ fact)])
            [1 0] (range 1 (inc n)))))

(doseq [n (range 11)]
  (println (format "!%-3d = %5d" n (left-factorial n))))

(doseq [n (range 20 111 10)]
(println (format "!%-3d = %5d" n (biginteger (left-factorial n)))))

(doseq [n (range 1000 10001 1000)]
  (println (format "!%-5d has %5d digits" n (count (str (biginteger (left-factorial n)))))))
