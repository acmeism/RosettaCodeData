(defn compose [f g]
  (fn [x]
    (f (g x))))
