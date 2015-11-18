(ns zebra
  (:require [clojure.math.combinatorics :as c]))

(defn solve
  []
  (let [arrangements (c/permutations (range 5))
        before? #(= (inc %1) %2)
        after? #(= (dec %1) %2)
        next-to? #(or (before? %1 %2) (after? %1 %2))]
    (for [[english swede dane norwegian german :as persons] arrangements
          :when (zero? norwegian)
          [red green white yellow blue :as colors] arrangements
          :when (before? green white)
          :when (= english red)
          :when (after? blue norwegian)
          [tea coffee milk beer water :as drinks] arrangements
          :when (= 2 milk)
          :when (= dane tea)
          :when (= coffee green)
          [pall-mall dunhill blend blue-master prince :as cigs] arrangements
          :when (= german prince)
          :when (= yellow dunhill)
          :when (= blue-master beer)
          :when (after? blend water)
          [dog birds cats horse zebra :as pets] arrangements
          :when (= swede dog)
          :when (= pall-mall birds)
          :when (next-to? blend cats)
          :when (after? horse dunhill)]
      (->> [[:english :swede :dane :norwegian :german]
            [:red :green :white :yellow :blue]
            [:tea :coffee :milk :beer :water]
            [:pall-mall :dunhill :blend :blue-master :prince]
            [:dog :birds :cats :horse :zebra]]
           (map zipmap [persons colors drinks cigs pets])))))


(defn -main
  [& _]
  (doseq [[[persons _ _ _ pets :as solution] i]
          (map vector (solve) (iterate inc 1))
          :let [zebra-house (some #(when (= :zebra (val %)) (key %)) pets)]]
    (println "solution" i)
    (println "The" (persons zebra-house) "owns the zebra.")
    (println "house nationality color   drink   cig          pet")
    (println "----- ----------- ------- ------- ------------ ------")
    (dotimes [i 5]
      (println (apply format "%5s %-11s %-7s %-7s %-12s %-6s"
                      (map #(% i) (cons inc solution)))))))
