(ns primes-found-app
  (:require [clojure.string :as str])
  (:gen-class))

(defn is-prime? [n]
  (if (< 1 n)
    (empty? (filter #(= 0 (mod n %)) (range 2 n)))
    false))

(defn get-prime-numbers [n]
  (filter is-prime? (take n (range))))

(defn numbers-to-str [xs]
  (map #(str %) xs))

(defn is-includes-123? [s]
  (str/includes? s "123"))

(defn solution [number]
  (->>
   (get-prime-numbers number)
   (numbers-to-str)
   (filter is-includes-123?)))

(defn main []
  (let [result (count (solution 1000000))]
  (prn (solution 100000))
  (format "There are %d primes that contain '123' below 1000000." result)
  ))

(main)

