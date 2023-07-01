(defn TriangleList [n]
  (let [l (map inc (range))]
    (loop [l l x 1 nl []]
      (if (= n (count nl))
        nl
        (recur (drop x l) (inc x) (conj nl (take x l)))))))

(defn TrianglePrint [n]
  (let [t (TriangleList n)
        m (count (str (last (last t))))
        f (map #(map str %) t)
        l (map #(map (fn [x] (if (> m (count x))
                               (str (apply str (take (- m (count x))
                                                     (repeat " "))) x)
                               x)) %) f)
        e (map #(map (fn [x] (str " " x)) %) l)]
    (map #(println (apply str %)) e)))
