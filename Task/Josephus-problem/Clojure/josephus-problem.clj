(defn rotate [n s] (lazy-cat (drop n s) (take n s)))

(defn josephus [n k]
   (letfn [(survivor [[ h & r :as l] k]
             (cond (empty? r) h
                   :else      (survivor (rest (rotate (dec k) l)) k)))]
     (survivor (range n) k)))

(let [n 41 k 3]
   (println (str "Given " n " prisoners in a circle numbered 1.." n
                 ", an executioner moving around the"))
   (println (str "circle " k " at a time will leave prisoner number "
                 (inc (josephus n k)) " as the last survivor.")))
