(defn open-doors [] (->> (iterate inc 1) (map #(* % %)) (take-while #(<= % 100))))

(defn print-open-doors []
  (println
    "Open doors after 100 passes:"
    (apply str (interpose ", " (open-doors)))))
