(dotimes (i 100)
  (println
   (cond
    ((= 0 (% i 15)) "FizzBuzz")
    ((= 0 (% i 3)) "Fizz")
    ((= 0 (% i 5)) "Buzz")
    ('t i))))
