(defn s-of-n-fn-creator [n]
  (fn [[sample iprev] item]
    (let [i (inc iprev)]
      (if (<= i n)
        [(conj sample item) i]
        (let [r (rand-int i)]
          (if (< r n)
            [(assoc sample r item) i]
            [sample i]))))))

(def s-of-3-fn (s-of-n-fn-creator 3))

(->> #(reduce s-of-3-fn [[] 0] (range 10))
    (repeatedly 100000)
    (map first)
    flatten
    frequencies
    sort
    println)
