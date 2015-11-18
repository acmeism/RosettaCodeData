(defn stateful-std-deviation[x]
  (letfn [(std-dev[x]
            (let [v (deref (find-var (symbol (str *ns* "/v"))))]
              (swap! v conj x)
              (let [m (/ (reduce + @v) (count @v))]
                (Math/sqrt (/ (reduce + (map #(* (- m %) (- m %)) @v)) (count @v))))))]
    (when (nil? (resolve 'v))
      (intern *ns* 'v (atom [])))
    (std-dev x)))
