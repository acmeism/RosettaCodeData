(map #(nth (conj (cycle [% % "Fizz" % "Buzz" "Fizz" % % % "Buzz" % "Fizz" % % "FizzBuzz"]) %) %) (range 1 101))
