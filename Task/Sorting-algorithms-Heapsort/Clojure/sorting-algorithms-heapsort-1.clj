(defn- swap [a i j]
  (assoc a i (nth a j) j (nth a i)))

(defn- sift [a pred k l]
  (loop [a a x k y (inc (* 2 k))]
    (if (< (inc (* 2 x)) l)
      (let [ch (if (and (< y (dec l)) (pred (nth a y) (nth a (inc y))))
                 (inc y)
                 y)]
        (if (pred (nth a x) (nth a ch))
          (recur (swap a x ch) ch (inc (* 2 ch)))
          a))
      a)))

(defn- heapify[pred a len]
  (reduce (fn [c term] (sift (swap c term 0) pred 0 term))
          (reduce (fn [c i] (sift c pred i len))
                  (vec a)
                  (range (dec (int (/ len 2))) -1 -1))
          (range (dec len) 0 -1)))

(defn heap-sort
  ([a pred]
   (let [len (count a)]
     (heapify pred a len)))
  ([a]
     (heap-sort a <)))
