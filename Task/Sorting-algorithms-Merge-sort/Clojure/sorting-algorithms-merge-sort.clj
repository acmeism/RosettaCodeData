(defn merge [left right]
  (cond (nil? left) right
        (nil? right) left
        :else (let [[l & *left] left
                    [r & *right] right]
                (if (<= l r) (cons l (merge *left right))
                             (cons r (merge left *right))))))

(defn merge-sort [list]
  (if (< (count list) 2)
    list
    (let [[left right] (split-at (/ (count list) 2) list)]
      (merge (merge-sort left) (merge-sort right)))))
