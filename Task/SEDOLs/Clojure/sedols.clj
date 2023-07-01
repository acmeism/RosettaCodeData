(defn sedols [xs]
  (letfn [(sedol [ys] (let [weights [1 3 1 7 3 9]
                            convtonum (map #(Character/getNumericValue %) ys)
                            check (-> (reduce + (map * weights convtonum)) (rem 10) (->> (- 10)) (rem 10))]
                        (str ys check)))]
    (map #(sedol %) xs)))
