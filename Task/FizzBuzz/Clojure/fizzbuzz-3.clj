(map (fn [x] (cond (zero? (mod x 15)) "FizzBuzz"
                   (zero? (mod x 5)) "Buzz"
                   (zero? (mod x 3)) "Fizz"
		     :else x))
     (range 1 101))
