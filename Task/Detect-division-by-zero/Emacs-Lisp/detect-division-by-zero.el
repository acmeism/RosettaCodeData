(condition-case nil
    (/ 1 0)
  (arith-error
   (message "Divide by zero (either integer or float)")))
