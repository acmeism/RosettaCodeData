(defn entropy [s]
  (let [len (count s), log-2 (Math/log 2)]
    (->> (frequencies s)
         (map (fn [[_ v]]
                (let [rf (/ v len)]
                  (-> (Math/log rf) (/ log-2) (* rf) Math/abs))))
         (reduce +))))

(defn fibonacci [cat a b]
  (lazy-seq
    (cons a (fibonacci b (cat a b)))))

; you could also say (fibonacci + 0 1) or (fibonacci concat '(0) '(1))

(printf "%2s %10s %17s %s%n" "N" "Length" "Entropy" "Fibword")
(doseq [i (range 1 38)
        w (take 37 (fibonacci str "1" "0"))]
  (printf "%2d %10d %.15f %s%n" i (count w) (entropy w) (if (<= i 8) w "..."))))
