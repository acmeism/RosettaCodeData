(defn factorial-iter [product counter max-count]
  (if (> counter max-count)
    product
    (factorial-iter (* counter product) (inc counter) max-count)))

(defn factorial [n]
  (factorial-iter 1 1 n))
