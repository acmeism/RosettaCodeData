(defn doors []
  (let [doors (into-array (repeat 100 false))]
    (doseq [pass   (range 1 101)
            i      (range (dec pass) 100 pass) ]
      (aset doors i (not (aget doors i))))
    doors))

(defn open-doors [] (for [[d n] (map vector (doors) (iterate inc 1)) :when d] n))

(defn print-open-doors []
  (println
    "Open doors after 100 passes:"
    (apply str (interpose ", " (open-doors)))))
