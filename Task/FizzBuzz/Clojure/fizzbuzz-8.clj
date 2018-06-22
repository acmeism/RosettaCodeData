(take 100 (map #(let [s (str %2 %3) ] (if (seq s) s (inc %)) )
            (range)
            (cycle [ "" "" "Fizz" ])
            (cycle [ "" "" "" "" "Buzz" ])))
