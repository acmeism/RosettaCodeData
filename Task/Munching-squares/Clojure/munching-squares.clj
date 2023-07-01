(let [n 16]
  (loop [i 0]
    (print "\033[0;0f\033[2J")
    (doseq [y (range n)]
      (doseq [x (range n)]
        (print (if (< (bit-xor x y) i) "█" " ")))
      (print "\n"))
    (flush)
    (Thread/sleep 150)
    (recur (mod (inc i) (inc n)))))
