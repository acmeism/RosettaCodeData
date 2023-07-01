(defn factorial [x]
    (cond
        (< x 0) nil
        (= x 0) 1
        (do
            (var fac 1)
            (for i 1 (inc x)
                (*= fac i))
            fac)))
