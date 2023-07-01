(defn trapped-water [towers]
  (let [maxes #(reductions max %)                ; the seq of increasing max values found in the input seq
        maxl  (maxes towers)                     ; the seq of max heights to the left of each tower
        maxr  (reverse (maxes (reverse towers))) ; the seq of max heights to the right of each tower
        mins  (map min maxl maxr)]               ; minimum highest surrounding tower per position
    (reduce + (map - mins towers))))             ; sum up the trapped water per position
