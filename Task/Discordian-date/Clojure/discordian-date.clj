(require '[clj-time.core :as tc])

(def seasons ["Chaos" "Discord" "Confusion" "Bureaucracy" "The Aftermath"])
(def weekdays ["Sweetmorn" "Boomtime" "Pungenday" "Prickle-Prickle" "Setting Orange"])
(def year-offset 1166)

(defn leap-year? [year]
  (= 29 (tc/number-of-days-in-the-month year 2)))

(defn discordian-day [day leap]
  (let [offset (if (and leap (>= day 59)) 1 0)
        day-off (- day offset)
        day-num (inc (rem day-off 73))
        season (seasons (quot day-off 73))
        weekday (weekdays (mod day-off 5))]
    (if (and (= day 59) (= offset 1))
      "St. Tib's Day"
      (str weekday ", " season " " day-num))))

(defn discordian-date [year month day]
  (let [day-of-year (dec (.getDayOfYear (tc/date-time year month day)))
        dday (discordian-day day-of-year (leap-year? year))]
    (format "%s, YOLD %s" dday (+ year year-offset))))
