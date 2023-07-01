(defn in-order? [order xs]
  (or (empty? xs)
      (apply order xs)))

(defn bogosort [order xs]
  (if (in-order? order xs) xs
    (recur order (shuffle xs))))

(println (bogosort < [7 5 12 1 4 2 23 18]))
