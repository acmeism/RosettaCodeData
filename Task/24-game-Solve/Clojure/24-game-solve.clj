(ns rosettacode.24game.solve
  (:require [clojure.math.combinatorics :as c]
            [clojure.walk :as w]))

(def ^:private op-maps
  (map #(zipmap [:o1 :o2 :o3] %) (c/selections '(* + - /) 3)))

(def ^:private patterns '(
  (:o1 (:o2 :n1 :n2) (:o3 :n3 :n4))
  (:o1 :n1 (:o2 :n2 (:o3 :n3 :n4)))
  (:o1 (:o2 (:o3 :n1 :n2) :n3) :n4)))

(defn play24 [& digits]
  {:pre (and (every? #(not= 0 %) digits)
             (= (count digits) 4))}
  (->> (for [:let [digit-maps
                     (->> digits sort c/permutations
                          (map #(zipmap [:n1 :n2 :n3 :n4] %)))]
             om op-maps, dm digit-maps]
         (w/prewalk-replace dm
           (w/prewalk-replace om patterns)))
       (filter #(= (eval %) 24))
       (map println)
       doall
       count))
