(for [i (range 1 101)] (print (cond
  [(not (% i 15)) "FizzBuzz"]
  [(not (% i  5)) "Buzz"]
  [(not (% i  3)) "Fizz"]
  [True           i])))
