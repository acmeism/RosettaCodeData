;; Functional (most elegant and best suited to Lisp dialects):
(defun fact (n)
  "Return the factorial of integer N, which require to be positive or 0."
  ;; Elisp won't do any type checking automatically, so
  ;; good practice would be doing that ourselves:
  (if (not (and (integerp n) (>= n 0)))
      (error "Function fact (N): Not a natural number or 0: %S" n))
  ;; But the actual code is very short:
  (apply '* (number-sequence 1 n)))
  ;; (For N = 0, number-sequence returns the empty list, resp. nil,
  ;; and the * function works with zero arguments, returning 1.)
