(def deck (into [] (for [rank "A23456789TJQK" suit "CDHS"] (str rank suit))))

(defn lcg [seed]
  (map #(bit-shift-right % 16)
    (rest (iterate #(mod (+ (* % 214013) 2531011) (bit-shift-left 1 31)) seed))))

(defn gen [seed]
  (map (fn [rnd rng] (into [] [(mod rnd rng) (dec rng)]))
    (lcg seed) (range 52 0 -1)))

(defn xchg [v [src dst]] (assoc v dst (v src) src (v dst)))

(defn show [seed] (map #(println %) (partition 8 8 ""
  (reverse (reduce xchg deck (gen seed))))))

(show 1)
