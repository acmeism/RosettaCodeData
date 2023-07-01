(def *forks* (cycle (take 5 (repeatedly #(make-fork)))))

(def *philosophers*
  (doall (map #(make-philosopher %1 [(nth *forks* %2) (nth *forks* (inc %2))] 1000)
              ["Aristotle" "Kant" "Spinoza" "Marx" "Russell"]
              (range 5))))

(defn start []
  (doseq [phil *philosophers*]
    (.start (Thread. #(dine phil 5 100 100)))))

(defn status []
  (dosync
    (doseq [i (range 5)]
      (let [f @(nth *forks* i)
            p @(nth *philosophers* i)]
        (println (str "fork: available=" f))
        (println (str (:name p)
                      ": eating=" (:eating? p)
                      " food=" (:food p)))))))
