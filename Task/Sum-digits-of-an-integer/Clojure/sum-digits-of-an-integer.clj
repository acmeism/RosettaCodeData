(defn sum-digits [n base]
  (let [number (if-not (string? n) (Long/toString n base) n)]
    (reduce + (map #(Long/valueOf (str %) base) number))))
