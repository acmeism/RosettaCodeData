(defn spiral [n]
  (let [cyc (cycle [1 n -1 (- n)])]
    (->> (range (dec n) 0 -1)
         (mapcat #(repeat 2 %))
         (cons n)
         #(mapcat repeat % cyc)
         (reductions +)
         (map vector (range 0 (* n n)))
         (sort-by second)
         (map first)))

(let [n 5]
  (clojure.pprint/cl-format
    true
    (str " ~{~<~%~," (* n 3) ":;~2d ~>~}~%")
    (spiral n)))
