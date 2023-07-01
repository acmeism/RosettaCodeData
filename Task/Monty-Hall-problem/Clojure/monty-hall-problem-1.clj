(ns monty-hall-problem
  (:use [clojure.contrib.seq :only (shuffle)]))

(defn play-game [staying]
  (let [doors (shuffle [:goat :goat :car])
        choice (rand-int 3)
        [a b] (filter #(not= choice %) (range 3))
        alternative (if (= :goat (nth doors a)) b a)]
    (= :car (nth doors (if staying choice alternative)))))

(defn simulate [staying times]
  (let [wins (reduce (fn [counter _] (if (play-game staying) (inc counter) counter))
                     0
                     (range times))]
    (str "wins " wins " times out of " times)))
