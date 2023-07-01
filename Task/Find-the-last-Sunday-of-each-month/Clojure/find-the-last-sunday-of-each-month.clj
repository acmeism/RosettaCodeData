(ns last-sundays.core
  (:require [clj-time.core :as time]
            [clj-time.periodic :refer [periodic-seq]]
            [clj-time.format :as fmt])
  (:import (org.joda.time DateTime DateTimeConstants))
  (:gen-class))

(defn sunday? [t]
  (= (.getDayOfWeek t) (DateTimeConstants/SUNDAY)))

(defn sundays [year]
  (take-while #(= (time/year %) year)
              (filter sunday? (periodic-seq (time/date-time year 1 1) (time/days 1)))))

(defn last-sundays-of-months [year]
  (->> (sundays year)
       (group-by time/month)
       (vals)
       (map (comp first #(sort-by time/day > %)))
       (map #(fmt/unparse (fmt/formatters :year-month-day) %))
       (interpose "\n")
       (apply str)))

(defn -main [& args]
  (println (last-sundays-of-months (Integer. (first args)))))
