(defn make-fork []
  (ref true))

(defn make-philosopher [name forks food-amt]
  (ref {:name name :forks forks :eating? false :food food-amt}))

(defn start-eating [phil]
  (dosync
    (if (every? true? (map ensure (:forks @phil)))  ; <-- the essential solution
      (do
        (doseq [f (:forks @phil)] (alter f not))
        (alter phil assoc :eating? true)
        (alter phil update-in [:food] dec)
        true)
      false)))

(defn stop-eating [phil]
  (dosync
    (when (:eating? @phil)
      (alter phil assoc :eating? false)
      (doseq [f (:forks @phil)] (alter f not)))))

(defn dine [phil retry-interval max-eat-duration max-think-duration]
  (while (pos? (:food @phil))
    (if (start-eating phil)
      (do
        (Thread/sleep (rand-int max-eat-duration))
        (stop-eating phil)
        (Thread/sleep (rand-int max-think-duration)))
      (Thread/sleep retry-interval))))
