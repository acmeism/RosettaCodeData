(take 100
   (map-indexed
      #(if (number? %2) (+ %1 %2) %2)
      (cycle [1 1 "Fizz" 1 "Buzz" "Fizz" 1 1 "Fizz" "Buzz" 1 "Fizz" 1 1 "FizzBuzz"])
      )
)
