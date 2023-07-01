(def n 8)
(def balls* (atom [{:x n :y 0}]))
(def board* (atom (vec (repeat (inc n) (vec (repeat (inc (* 2 n)) " "))))))
(doseq [y (range (inc n))
        i (range y)]
  (swap! board* assoc-in [y (+ (- n y) (* 2 i) 1)] "^"))
(def histogram* (atom (vec (repeat (inc (* 2 n)) 0))))

(loop [frame 0]
  (print "\033[0;0f\033[2J")
  (doseq [row @board*] (println (apply str row)))
  (let [depth (inc (apply max (map #(quot % 8) @histogram*)))]
    (dotimes [y depth]
      (doseq [i @histogram*]
        (print (nth " ▁▂▃▄▅▆▇█" (min 8 (max 0 (- i (* (- depth y 1) 8)))))))
      (print "\n")))
  (println "\n")
  (flush)
  (doseq [[i {:keys [x y]}] (map-indexed vector @balls*)]
    (swap! board* assoc-in [y x] " ")
    (let [[new-x new-y] [(if (< 0.5 (rand)) (inc x) (dec x)) (inc y)]]
      (if (> new-y n)
        (do (swap! histogram* update x inc)
            (swap! balls* assoc i {:x n :y 0}))
        (do (swap! board* assoc-in [new-y new-x] "*")
            (swap! balls* assoc i {:x new-x :y new-y})))))
  (Thread/sleep 200)
  (when (< (count @balls*) n) (swap! balls* conj {:x n :y 0}))
  (when (< frame 200) (recur (inc frame))))
