(defn qs [q]
  (let [n (count q)]
    (condp = n
      0 [1]
      1 [1 1]
      (conj q (+ (q (- n (q (- n 1))))
                 (q (- n (q (- n 2)))))))))

(defn qfirst [n] (-> (iterate qs []) (nth n)))

(println "first 10:" (qfirst 10))
(println "1000th:" (last (qfirst 1000)))
(println "extra credit:" (->> (qfirst 100000) (partition 2 1) (filter #(apply > %)) count))
