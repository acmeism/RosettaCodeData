(def items
  [{:name "beef" :weight 3.8 :price 36}
   {:name "pork" :weight 5.4 :price 43}
   {:name "ham" :weight 3.6 :price 90}
   {:name "graves" :weight 2.4 :price 45}
   {:name "flitch" :weight 4.0 :price 30}
   {:name "brawn" :weight 2.5 :price 56}
   {:name "welt" :weight 3.7 :price 67}
   {:name "salami" :weight 3.0 :price 95}
   {:name "sausage" :weight 5.9 :price 98}])

(defn per-kg [item] (/ (:price item) (:weight item)))

(defn rob [items capacity]
  (let [best-items (reverse (sort-by per-kg items))]
    (loop [items best-items cap capacity total 0]
      (let [item (first items)]
        (if (< (:weight item) cap)
          (do (println (str "Take all " (:name item)))
              (recur (rest items) (- cap (:weight item)) (+ total (:price item))))
          (println (format "Take %.1f kg of %s\nTotal: %.2f monies"
                           cap (:name item) (+ total (* cap (per-kg item))))))))))

(rob items 15)
