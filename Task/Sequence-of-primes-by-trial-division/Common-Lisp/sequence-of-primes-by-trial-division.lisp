(defun primes-up-to (max-number)
    "Compute all primes up to MAX-NUMBER using trial division"
    (loop for n from 2 upto max-number
          when (notany (evenly-divides n) primes)
          collect n into primes
          finally (return primes)))

(defun evenly-divides (n)
    "Create a function that checks whether its input divides N evenly"
    (lambda (x) (integerp (/ n x))))

(print (primes-up-to 100))
