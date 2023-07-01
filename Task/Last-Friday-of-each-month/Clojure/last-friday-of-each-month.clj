(use '[clj-time.core :only [last-day-of-the-month day-of-week minus days]]
     '[clj-time.format :only [unparse formatters]])

(defn last-fridays [year]
  (let [last-days (map #(last-day-of-the-month year %) (range 1 13 1))
        dow (map day-of-week last-days)
        relation (zipmap last-days dow)]
    (map #(minus (key %) (days (mod (+ (val %) 2) 7))) relation)))

(defn last-fridays-formatted [year]
  (sort (map #(unparse (formatters :year-month-day) %) (last-fridays year))))
