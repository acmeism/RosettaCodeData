(map (fn [n]
       (if-let [fb (seq (concat (when (zero? (mod n 3)) "Fizz")
                                (when (zero? (mod n 5)) "Buzz")))]
           (apply str fb)
           n))
     (range 1 101))
