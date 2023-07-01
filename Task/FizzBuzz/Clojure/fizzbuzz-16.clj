(take 100
       (->>
          (map str (cycle [nil nil "Fizz"]) (cycle [nil nil nil nil "Buzz"]))
          (map-indexed #(if (empty? %2) (inc %1) %2))
       )
)
