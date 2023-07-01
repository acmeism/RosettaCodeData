(defn powerset [coll]
  (let [cnt (count coll)
        bits (Math/pow 2 cnt)]
    (for [i (range bits)]
      (for [j (range i)
            :while (< j cnt)
            :when (bit-test i j)]
         (nth coll j)))))

(powerset [1 2 3])
