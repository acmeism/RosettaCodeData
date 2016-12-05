(take 100
   (map #(str %1 %2 (if-not (or %1 %2) %3))
        (cycle [nil nil "Fizz"])
        (cycle [nil nil nil nil "Buzz"])
        (rest (range))
   ))
