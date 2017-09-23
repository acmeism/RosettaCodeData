(def max 100)

(defn roll-dice []
  (let [roll (inc (rand-int 6))]
    (println "Rolled:" roll) roll))

(defn switch [player]
  (if (= player :player1) :player2 :player1))

(defn find-winner [game]
  (cond
    (>= (:player1 game) max) :player1
    (>= (:player2 game) max) :player2
    :else nil))

(defn bust []
  (println "Busted!") 0)

(defn hold [points]
  (println "Sticking with" points) points)

(defn play-round [game player temp-points]
  (println (format "%s: (%s, %s).  Want to Roll? (y/n) " (name player) (player game) temp-points))
  (let [input (clojure.string/upper-case (read-line))]
    (if (.equals input "Y")
      (let [roll (roll-dice)]
        (if (= 1 roll)
          (bust)
          (play-round game player (+ roll temp-points))))
      (hold temp-points))))

(defn play-game [game player]
    (let [winner (find-winner game)]
      (if (nil? winner)
        (let [points (play-round game player 0)]
          (recur (assoc game player (+ points (player game))) (switch player)))
        (println (name winner) "wins!"))))

(defn -main [& args]
  (println "Pig the Dice Game.")
  (play-game {:player1 0, :player2 0} :player1))
