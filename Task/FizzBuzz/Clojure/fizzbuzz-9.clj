(map #(nth (conj (cycle [% % "Fizz" % "Buzz" "Fizz" % % "Fizz" "Buzz" % "Fizz" % % "FizzBuzz"]) %) %) (range 1 101))
