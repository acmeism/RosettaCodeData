(ns penney.core
  (:gen-class))

(def heads \H)
(def tails \T)

(defn flip-coin []
  (let [flip (rand-int 2)]
    (if (= flip 0) heads tails)))

(defn turn [coin]
  (if (= coin heads) tails heads))

(defn first-index [combo coll]
  (some #(if (= (second %) combo) (first %)) coll))

(defn find-winner [h c]
  (if (< h c)
    (do (println "YOU WIN!\n") :human)
    (do (println "COMPUTER WINS!\n") :computer)))

(defn flip-off [human comp]
  (let [flips (repeatedly flip-coin)
        idx-flips (map-indexed vector (partition 3 1 flips))
        h (first-index (seq human) idx-flips)
        c (first-index (seq comp) idx-flips)]
    (println (format "Tosses: %s" (apply str (take (+ 3 (min h c)) flips))))
    (find-winner h c)))

(defn valid? [combo]
  (if (empty? combo) true (and (= 3 (count combo)) (every? #(or (= heads %) (= tails %)) combo))))

(defn ask-move []
  (println "What sequence of 3 Heads/Tails do you choose?")
  (let [input (clojure.string/upper-case (read-line))]
    (if-not (valid? input) (recur) input)))

(defn optimize-against [combo]
  (let [mid (nth combo 1)
        comp (str (turn mid) (first combo) mid)]
    (println (format "Computer chooses %s: " comp)) comp))

(defn initial-move [game]
  (let [combo (apply str (repeatedly 3 flip-coin))]
    (println "--------------")
    (println (format "Current score | CPU: %s, You: %s" (:computer game) (:human game)))
    (if (= (:first-player game) tails)
      (do
        (println "Computer goes first and chooses: " combo)
        combo)
      (println "YOU get to go first."))))

(defn play-game [game]
    (let [c-move (initial-move game)
          h-move (ask-move)]
      (if-not (empty? h-move)
        (let [winner (flip-off h-move (if (nil? c-move) (optimize-against h-move) c-move))]
          (recur (assoc game winner (inc (winner game)) :first-player (flip-coin))))
        (println "Thanks for playing!"))))

(defn -main [& args]
  (println "Penney's Game.")
  (play-game {:first-player (flip-coin)
              :human 0, :computer 0}))
