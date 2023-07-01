(defn super [d]
  (let [run (apply str (repeat d (str d)))]
   (filter #(clojure.string/includes? (str (* d (Math/pow % d ))) run) (range))))

(doseq [d (range 2 9)]
    (println (str d ": ") (take 10 (super d))))
