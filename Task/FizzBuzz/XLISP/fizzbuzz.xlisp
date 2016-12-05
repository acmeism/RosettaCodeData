(defun fizzbuzz ()
    (defun fizzb (x y)
        (display (cond
            ((= (mod x 3) (mod x 5) 0) "FizzBuzz")
            ((= (mod x 3) 0) "Fizz")
            ((= (mod x 5) 0) "Buzz")
            (t x)))
        (newline)
        (if (< x y)
            (fizzb (+ x 1) y)))
    (fizzb 1 100))

(fizzbuzz)
