(defun fib (number)
  "Fibonacci sequence function."
  (if (< number 0)
      (error "Error. The number entered: ~A is negative" number)
      (labels ((fib1 (n a b)
                 (if (= n 0)
                     a
                     (fib1 (- n 1) b (+ a b)))))
        (fib1 number 0 1))))
