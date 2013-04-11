(ns one-dimensional-cellular-automata
  (:require (clojure.contrib (string :as s))))

(defn next-gen [cells]
  (loop [cs cells ncs (s/take 1 cells)]
    (let [f3 (s/take 3 cs)]
      (if (= 3 (count f3))
        (recur (s/drop 1 cs)
               (str ncs (if (= 2 (count (filter #(= \# %) f3))) "#" "_")))
        (str ncs (s/drop 1 cs))))))

(defn generate [n cells]
  (if (= n 0)
    '()
    (cons cells (generate (dec n) (next-gen cells)))))
