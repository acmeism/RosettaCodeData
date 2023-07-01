(ns async-example.core
  (:require [clojure.math.numeric-tower :as math])
  (:use [criterium.core])
  (:gen-class))

(defn get-digits [n]
  " Convert number of a list of digits  (e.g. 545 -> ((5), (4), (5)) "
  (map #(Integer/valueOf (str %)) (String/valueOf n)))

(defn sum-power [digits]
  " Convert digits such as abc... to a^a + b^b + c^c ..."
  (let [digits-pwr (fn [n]
                     (apply + (map #(math/expt % %) digits)))]
    (digits-pwr digits)))

(defn find-numbers [max-range]
  " Filters for Munchausen numbers "
  (->>
    (range 1 (inc max-range))
    (filter #(= (sum-power (get-digits %)) %))))


(println (find-numbers 5000))
