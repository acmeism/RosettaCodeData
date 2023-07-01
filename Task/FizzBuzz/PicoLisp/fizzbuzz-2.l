(for N 100
   (prinl
      (cond
         ((=0 (% N 15)) "FizzBuzz")
         ((=0 (% N 3)) "Fizz")
         ((=0 (% N 5)) "Buzz")
         (T N) ) ) )
