(defn doors []
  (reduce (fn [doors toggle-idx] (update-in doors [toggle-idx] not))
          (into [] (repeat 100 false))
          (for [pass   (range 1 101)
                i      (range (dec pass) 100 pass) ]
            i)))

(defn open-doors [] (for [[d n] (map vector (doors) (iterate inc 1)) :when d] n))

(defn print-open-doors []
  (println
    "Open doors after 100 passes:"
    (apply str (interpose ", " (open-doors)))))
