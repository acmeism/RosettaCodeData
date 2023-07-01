(defn dig-root [value]
  (let [digits (fn [n]
                 (map #(- (byte %) (byte \0))
                      (str n)))
        sum    (fn [nums]
                 (reduce + nums))]
    (loop [n    value
           step 0]
      (if (< n 10)
        {:n value :add-persist step :digital-root n}
        (recur (sum (digits n))
               (inc step))))))
