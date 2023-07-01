(define fizzbuzz
  101 -> (nl)
  N -> (let divisible-by? (/. A B (integer? (/ A B)))
         (cases (divisible-by? N 15) (do (output "Fizzbuzz!~%")
                                         (fizzbuzz (+ N 1)))
                (divisible-by? N 3) (do (output "Fizz!~%")
                                        (fizzbuzz (+ N 1)))
                (divisible-by? N 5) (do (output "Buzz!~%")
                                        (fizzbuzz (+ N 1)))
                true (do (output (str N))
                         (nl)
                         (fizzbuzz (+ N 1))))))

(fizzbuzz 1)
