(defn leap? [y]
    (and
        (= (% y 4) 0)
        (or
            (!= (% y 100) 0)
            (= (% y 400) 0))))
