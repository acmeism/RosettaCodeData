(define (fizzbuzz x y)
  (println
    (cond (( = (modulo x 15) 0 ) "FizzBuzz")
          (( = (modulo x 3) 0 ) "Fizz")
          (( = (modulo x 5) 0 ) "Buzz")
          (else x)))

    (if (< x y) (fizzbuzz (+ x 1) y)))

(fizzbuzz 1 100)
