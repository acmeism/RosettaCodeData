(defun fib (number)
  "Fibonacci sequence function."
  (if (< number 0)
      (error "Error. The number entered: ~A is negative" number)
      (labels ((fib (n a b)
                 (if (= n 0)
                     a
                     (fib (- n 1) b (+ a b)))))
        (fib number 0 1))))
