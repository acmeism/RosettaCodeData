(defn fix [pairs]
  (map second pairs))

(defn getvalid [pairs n]
  (filter (fn [p] (zero? (mod n (first p))))
          (sort-by first pairs)))

(defn gfizzbuzz [pairs numbers]
  (interpose "\n"
             (map (fn [n] (let [f (getvalid pairs n)]
                            (if (empty? f)
                              n
                              (apply str
                                     (fix f)))))
                  numbers)))
