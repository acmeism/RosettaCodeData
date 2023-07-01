(def hailstone-src
  "(defn hailstone-step [env]
     (let [{:keys[n cnt]} env]
       (cond
         (= n 1)   {:n 1 :cnt cnt}
         (even? n) {:n (/ n 2) :cnt (inc cnt)}
         :else     {:n (inc (* n 3)) :cnt (inc cnt)})))")

(defn create-hailstone-table [f-src]
  (let [done?        (fn [e] (= (:n e) 1))
        print-step   (fn [envs] (println (map #(format "%4d" (:n %)) envs)))
        print-counts (fn [envs] (println "Counts:\n"
                                         (map #(format "%4d" (:cnt %)) envs)))]
    (loop [f    (eval (read-string f-src))
           envs (for [n (range 12)]
                  {:n (inc n) :cnt 0})]
      (if (every? done? envs)
        (print-counts envs)
        (do
          (print-step envs)
          (recur f (map f envs)))))))
