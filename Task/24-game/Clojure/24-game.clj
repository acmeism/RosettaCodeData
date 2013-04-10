(ns rosettacode.24game)

(defn gen-new-game-nums [amount] (repeatedly amount #(inc ( rand-int 9))))

(defn orderless-seq-eq? [seq1 seq2] (apply = (map frequencies (list seq1 seq2))))

(defn valid-input?
  "checks whether the expression is somewhat valid prefix notation
 (+ 1 2 3 4) (+ 3 (+ 4 5) 6)
 this is done by making sure the only contents of the list are numbers operators and brackets
 flatten gets rid of the brackets, so we just need to test for operators and integers after that"
  [user-input]
  (if (re-find #"^\(([\d-+/*] )+\d?\)$" (pr-str (flatten user-input)))
    true
    false))

(defn game-numbers-and-user-input-same?
  "input form: (+ 1 2 (+ 3 4))
tests to see if the numbers the user entered are the same as the ones given to them by the game"
  [game-nums user-input]
  (orderless-seq-eq? game-nums (filter integer? (flatten  user-input))))

(defn win [] (println "you won the game!\n"))
(defn lose [] (println "you guessed wrong, or your input was not in prefix notation. eg: '(+ 1 2 3 4)'\n"))
(defn game-start [goal game-numbers] (do
                                       (println "Your numbers are " game-numbers)
                                       (println "Your goal is " goal)
                                       (println "Use the numbers and +*-/ to reach your goal\n")
                                       (println "'q' to Quit\n")))

(defn play-game
  "typing in 'q' quits.
   to play use (play-game) (play-game 24) or (play-game 24 '(1 2 3 4)"
  ([] (play-game 24))
  ([goal] (play-game goal (gen-new-game-nums 4)))
  ([goal game-numbers]
     (game-start goal game-numbers)
     (let [input  (read-line)
           input-as-code (read-string input)]
       (if (and (valid-input? input-as-code)
                (game-numbers-and-user-input-same? game-numbers input-as-code)
                (try (= goal (eval input-as-code)) (catch Exception e (do (lose) (play-game goal game-numbers)))))
         (win)
         (when (not (= input "q"))
           (do (lose) (recur goal game-numbers)))))))
