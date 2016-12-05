(def suits [:club :diamond :heart :spade])
(def pips [:ace 2 3 4 5 6 7 8 9 10 :jack :queen :king])

(defn deck [] (for [s suits p pips] [s p]))

(def shuffle clojure.core/shuffle)
(def deal first)
(defn output [deck]
  (doseq [[suit pip] deck]
    (println (format "%s of %ss"
                     (if (keyword? pip) (name pip) pip)
                     (name suit)))))
