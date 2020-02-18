;; Recursive:
(defun fact (n)
  "Return the factorial of integer N, which require to be positive or 0."
  (if (not (and (integerp n) (>= n 0))) ; see above
      (error "Function fact (N): Not a natural number or 0: %S" n))
  (cond ; (or use an (if ...) with an else part)
   ((or (= n 0) (= n 1)) 1)
    (t (* n (fact (1- n))))))
