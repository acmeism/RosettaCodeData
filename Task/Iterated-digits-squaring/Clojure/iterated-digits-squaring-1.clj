(ns async-example.core
  (:require [clojure.math.numeric-tower :as math])
  (:use [criterium.core])
  (:gen-class))
(defn sum-sqr [digits]
  " Square sum of list of digits "
  (let [digits-sqr (fn [n]
                     (apply + (map #(* % %) digits)))]
    (digits-sqr digits)))

(defn get-digits [n]
  " Converts a digit to a list of digits (e.g. 545 -> ((5) (4) (5)) (used for squaring digits) "
  (map #(Integer/valueOf (str %)) (String/valueOf n)))

(defn -isNot89 [x]
  " Returns nil on 89 "
  (cond
    (= x 0) 0
    (= x 89) nil
    (= x 1) 0
    (< x 10) (recur (* x x))
    :else (recur (sum-sqr (get-digits x)))))

;; Cached version of isNot89 (i.e. remembers prevents inputs, and returns result by looking it up when input repeated)
(def isNot89 (memoize -isNot89))

(defn direct-method [ndigits]
  " Simple approach of looping through all the numbers from 0 to 10^ndigits - 1 "
  (->>
    (math/expt 10 ndigits)
    (range 0)									; 0 to 10^ndigits
    (filter #(isNot89 (sum-sqr (get-digits %))))	; filters out 89
    (count)										; count non-89
    (- (math/expt 10 ndigits))))				; count 89 (10^ndigits - (count 89))


(time (println (direct-method 8)))
