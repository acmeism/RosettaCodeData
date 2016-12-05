(for n 1 100
  (prn:if
    (multiple n 15) 'FizzBuzz
    (multiple n 5) 'Buzz
    (multiple n 3) 'Fizz
    n))
