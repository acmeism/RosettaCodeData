(defn isin? [x li]
  (not= [] (filter #(= x %) li)))

(defn options [movements pmoves n]
  (let [x (first (last movements)) y (second (last movements))
        op (vec (map #(vector (+ x (first %)) (+ y (second %))) pmoves))
        vop (filter #(and (>= (first %) 0) (>= (last %) 0)) op)
        vop1 (filter #(and (< (first %) n) (< (last %) n)) vop)]
    (vec (filter #(not (isin? % movements)) vop1))))

(defn next-move [movements pmoves n]
  (let [op (options movements pmoves n)
        sp (map #(vector % (count (options (conj movements %) pmoves n))) op)
        m (apply min (map last sp))]
    (first (rand-nth (filter #(= m (last %)) sp)))))

(defn jumps [n pos]
  (let [movements (vector pos)
        pmoves [[1 2] [1 -2] [2 1] [2 -1]
                [-1 2] [-1 -2] [-2 -1] [-2 1]]]
    (loop [mov movements x 1]
      (if (= x (* n n))
        mov
        (let [np (next-move mov pmoves n)]
          (recur (conj mov np) (inc x)))))))
