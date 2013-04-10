(defun fib (number)
  "Fibonacci sequence function."
  (if (< number 0)
      (error "Error. The number entered: ~A is negative" number)
      (recursive ((n number) (a 0) (b 1))
         (if (= n 0)
            a
            (recurse (- n 1) b (+ a b))))))
