(take 100
      (map-indexed
        #(case %2 14 "FizzBuzz" (2 5 8 11) "Fizz" (4 9) "Buzz" (inc %1))
        (cycle (range 15))
        )
)
