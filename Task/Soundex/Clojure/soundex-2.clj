;;; With proper consecutive duplicates elimination

(defn get-code [c]
  (case c
    (\B \F \P \V) 1
    (\C \G \J \K
     \Q \S \X \Z) 2
    (\D \T) 3
    \L 4
    (\M \N) 5
    \R 6
    nil)) ;(\A \E \I \O \U \H \W \Y)

(defn reduce-fn [acc nxt]
 (let [next-code (get-code nxt)]
   (if (and (not= next-code (last acc))
            (not (nil? next-code)))
     (conj acc next-code)
     acc)))

(defn soundex [the-word]
  (let [[first-char & the-rest] (.toUpperCase the-word)
        next-code (get-code (first the-rest))]
    (if (nil? next-code)
      (recur (apply str first-char (rest the-rest)))
      (let [soundex-nums (reduce reduce-fn [] the-rest)]
        (apply str first-char (take 3 (conj soundex-nums 0 0 0)))))))
