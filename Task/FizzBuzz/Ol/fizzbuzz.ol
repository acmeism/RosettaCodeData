(for-each (lambda (x)
      (print (cond
         ((and (zero? (mod x 3)) (zero? (mod x 5)))
            "FizzBuzz")
         ((zero? (mod x 3))
            "Fizz")
         ((zero? (mod x 5))
            "Buzz")
         (else
            x))))
   (iota 100))
