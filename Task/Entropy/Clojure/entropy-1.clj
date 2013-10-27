(defn entropy [s]
  (let [len (count s)
        freqs (frequencies s)
        log-of-2 (Math/log 2)]
    (->> (keys freqs)
         (map (fn [c]
                (let [rf (/ (get freqs c) len)]
                  (* -1 rf (/ (Math/log rf) log-of-2)))))
         (reduce +))))
