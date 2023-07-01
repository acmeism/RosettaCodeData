(defn i->dir
  [n]
  (mod (Long/bitCount (bit-xor n (bit-shift-right n 1))) 4))

(defn safe-bit-or [v bit] (bit-or (or v 0) bit))

(let [steps 511
      {[minx maxx miny maxy] :bbox data :data}
      (loop [i 0
             [x y] [0 0]
             out {}
             [minx maxx miny maxy] [0 0 0 0]]
        (let [dir (i->dir i)
              [nx ny] [(+ x (condp = dir 0 1 2 -1 0))
                       (+ y (condp = dir 1 1 3 -1 0))]
              [ob ib] (nth [[8 4][2 1][4 8][1 2]] dir)
              out (-> (update-in out [y x] safe-bit-or ob)
                      (update-in [ny nx] safe-bit-or ib))
              bbox [(min minx nx) (max maxx nx)
                    (min miny ny) (max maxy ny)]]
          (if (< i steps)
            (recur (inc i) [nx ny] out bbox)
            {:data out :bbox bbox})))]
  (doseq [y (range miny (inc maxy))]
    (->> (for [x (range minx (inc maxx))]
           (nth " ╵╷│╴┘┐┤╶└┌├─┴┬┼" (get-in data [y x] 0)))
         (apply str)
         (println))))
