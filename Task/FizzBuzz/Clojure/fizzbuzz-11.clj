(take 100
      (map #(if (pos? (compare %1 %2)) %1 %2)
           (map str (drop 1 (range)))
           (map str (cycle ["" "" "Fizz"]) (cycle ["" "" "" "" "Buzz"]))))
