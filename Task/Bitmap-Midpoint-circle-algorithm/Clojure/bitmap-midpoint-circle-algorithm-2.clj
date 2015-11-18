(let [circle-points (atom [])]
    (letfn [(draw-fn [x y]
              (swap! circle-points #(conj % [x y])))]
      (draw-circle draw-fn 10 10 7))
    (let [empty-grid (vec (repeat 20 (vec (repeat 20 " "))))
          grid       (reduce (fn [grid xy] (assoc-in grid xy "x"))
                             empty-grid
                             @circle-points)]
      (doseq [line grid]
        (println (clojure.string/join line)))))
