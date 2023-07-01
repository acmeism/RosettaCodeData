(defn happy? [n]
  (loop [n n, seen #{}]
    (cond
      (= n 1)  true
      (seen n) false
      :else
        (recur (->> (str n)
                    (map #(Character/digit % 10))
                    (map #(* % %))
                    (reduce +))
               (conj seen n)))))

(def happy-numbers (filter happy? (iterate inc 1)))

(println (take 8 happy-numbers))
