(ns narcissistic.core
  (:require [clojure.math.numeric-tower :as math]))

(defn digits [n] ;; digits of a number.
  (->> n str (map (comp read-string str))))

(defn narcissistic? [n] ;; True if the number is a Narcissistic one.
  (let [d (digits n)
        s (count d)]
    (= n (reduce + (map #(math/expt % s) d)))))

(defn firstNnarc [n] ;;list of the first "n" Narcissistic numbers.
  (take n (filter narcissistic? (range))))
