(ns queens
  (:require [clojure.math.combinatorics :as combo]

(defn queens [n]
  (filter (fn [x] (every? #(apply distinct? (map-indexed % x)) [+ -]))
          (combo/permutations (range 1 (inc n)))))
