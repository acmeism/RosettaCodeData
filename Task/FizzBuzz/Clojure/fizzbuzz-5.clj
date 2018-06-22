(def fizzbuzz (map
  #(cond (zero? (mod % 15)) "FizzBuzz"
         (zero? (mod % 5)) "Buzz"
         (zero? (mod % 3)) "Fizz"
               :else %)
  (iterate inc 1)))
