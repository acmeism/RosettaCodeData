(ns rps.core
  (:require [clojure.data.generators :refer [weighted]])
  (:import jline.Terminal)
  (:gen-class))

(def what-beats {:rock :paper, :paper :scissors, :scissors :rock})

(defn battle [human comp]
  (let [h (name human)
        c (name comp)]
    (cond
      (= human comp) (println (format "We both picked %s. DRAW!" c))
      (= human (what-beats comp))
        (println (format "Your %s defeats computer's %s. YOU WIN!" h c))
      (= comp (what-beats human))
        (println (format "Computer's %s defeats your %s. YOU LOSE!" c h))
      :else (println (format "Wat? %s and %s ?" h c)))))

(defn key->rps [k]
  (cond
    (or (= k 82) (= k 114)) :rock
    (or (= k 80) (= k 112)) :paper
    (or (= k 83) (= k 115)) :scissors
    :else nil))

(defn play-game [freqs]
    (println "\n(R)ock, (P)aper, (S)cissors?")
    (let [term (Terminal/getTerminal)
          rps (key->rps (.readCharacter term System/in))]
      (if-not (nil? rps)
        (do
          (battle rps (what-beats (weighted freqs)))
          (recur (assoc freqs rps (inc (rps freqs)))))
        (println "Game Over Man!  Game Over!"))))

(defn -main
  "Rock, Paper, Scissors!"
  [& args]
  (play-game {:rock 1, :paper 1, :scissors 1}))
