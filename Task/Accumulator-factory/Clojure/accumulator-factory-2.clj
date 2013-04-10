(defn accum [n]
  (let [acc (ref n)]
    #(dosync (alter acc + %))))
