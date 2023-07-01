(def records [{:idx 8, :name "Abidjan",              :population  4.4}
              {:idx 7, :name "Alexandria",           :population  4.58}
              {:idx 1, :name "Cairo",                :population 15.2}
              {:idx 9, :name "Casablanca",           :population  3.98}
              {:idx 6, :name "Dar Es Salaam",        :population  4.7}
              {:idx 3, :name "Greater Johannesburg", :population  7.55}
              {:idx 5, :name "Khartoum-Omdurman",    :population  4.98}
              {:idx 2, :name "Kinshasa-Brazzaville", :population 11.3}
              {:idx 0, :name "Lagos",                :population 21.0}
              {:idx 4, :name "Mogadishu",            :population  5.85}])

(defn city->idx [recs city]
  (-> (some #(when (= city (:name %)) %)
            recs)
      :idx))

(defn rec-with-max-population-below-n [recs limit]
  (->> (sort-by :population > recs)
       (drop-while (fn [r] (>= (:population r) limit)))
       first))

(defn most-populous-city-below-n [recs limit]
  (:name (rec-with-max-population-below-n recs limit)))
