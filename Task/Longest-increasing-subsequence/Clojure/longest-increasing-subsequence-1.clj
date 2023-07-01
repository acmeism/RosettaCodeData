(defn place [piles card]
  (let [[les gts] (->> piles (split-with #(<= (ffirst %) card)))
        newelem (cons card (->> les last first))
        modpile (cons newelem (first gts))]
    (concat les (cons modpile (rest gts)))))

(defn a-longest [cards]
  (let [piles (reduce place '() cards)]
    (->> piles last first reverse)))

(println (a-longest [3 2 6 4 5 1]))
(println (a-longest [0 8 4 12 2 10 6 14 1 9 5 13 3 11 7 15]))
