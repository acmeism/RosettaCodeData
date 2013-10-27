(defn rand-seq-elem [sequence]
  (let [f (fn [[k old] new]
            [(inc k) (if (zero? (rand-int k)) new old)])]
    (->> sequence (reduce f [1 nil]) second)))

(defn one-of-n [n]
  (rand-seq-elem (range 1 (inc n))))

(let [countmap (frequencies (repeatedly 1000000 #(one-of-n 10)))]
  (doseq [[n cnt] (sort countmap)]
    (println n cnt)))
