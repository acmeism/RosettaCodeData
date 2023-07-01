(defn perfect-shuffle [deck]
  (let [half (split-at (/ (count deck) 2) deck)]
    (interleave (first half) (last half))))

(defn solve [deck-size]
  (let [original (range deck-size)
        trials (drop 1 (iterate perfect-shuffle original))
        predicate #(= original %)]
    (println (format "%5s: %s" deck-size
      (inc (some identity (map-indexed (fn [i x] (when (predicate x) i)) trials)))))))

(map solve [8 24 52 100 1020 1024 10000])
