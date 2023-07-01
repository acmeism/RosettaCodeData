(defn factorial [x]
    (cond
        (< x 0) nil
        (= x 0) 1
        (* x (factorial (dec x)))))
