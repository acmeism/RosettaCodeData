(defn cols [board]
  (mapv vec (apply map list board)))

(defn flipv [v]
  (mapv #(if (> % 0) 0 1) v))

(defn flip-row [board n]
  (assoc board n (flipv (get board n))))

(defn flip-col [board n]
  (cols (flip-row (cols board) n)))

(defn play-rand [board n]
  (if (= n 0)
    board
    (let [f (if (= (rand-int 2) 0) flip-row flip-col)]
      (recur (f board (rand-int (count board))) (dec n)))))

(defn rand-binary-vec [size]
  (vec (take size (repeatedly #(rand-int 2)))))

(defn rand-binary-board [size]
  (vec (take size (repeatedly #(rand-binary-vec size)))))

(defn numbers->letters [coll]
  (map #(char (+ 97 %)) coll))

(defn column-labels [size]
  (apply str (interpose " " (numbers->letters (range size)))))

(defn print-board [board]
  (let [size (count board)]
    (println "\t " (column-labels size))
    (dotimes [n size] (println (inc n) "\t" (board n)))))

(defn key->move [key]
  (let [start (int (first key))
        row-value (try (Long/valueOf key) (catch NumberFormatException e))]
    (cond
      (<= 97 start 122) [:col (- start 97)]
      (<= 65 start 90) [:col (- start 65)]
      (> row-value 0) [:row (dec row-value)]
      :else nil)))

(defn play-game [target-board current-board n]
  (println "\nTurn " n)
  (print-board current-board)
  (if (= target-board current-board)
    (println "You win!")
    (let [move (key->move (read-line))
          axis (first move)
          idx (second move)]
      (cond
        (= axis :row) (play-game target-board (flip-row current-board idx) (inc n))
        (= axis :col) (play-game target-board (flip-col current-board idx) (inc n))
        :else (println "Quitting!")))))

(defn -main
  "Flip the Bits Game!"
  [& args]
  (if-not (empty? args)
    (let [target-board (rand-binary-board (Long/valueOf (first args)))]
      (println "Target")
      (print-board target-board)
      (play-game target-board (play-rand target-board 3) 0))))
