(defn long-year? [year]
  (-> (java.time.LocalDate/of year 12 28)
      (.get (.weekOfYear (java.time.temporal.WeekFields/ISO)))
      (= 53)))

(filter long-year? (range 2000 2100))
