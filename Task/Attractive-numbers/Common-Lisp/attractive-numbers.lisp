(defun attractivep (n)
  (primep (length (factors n))) )

; For primality testing we can use different methods, but since we have to define factors that's what we'll use
(defun primep (n)
  (= (length (factors n)) 1) )

(defun factors (n)
  "Return a list of factors of N."
  (when (> n 1)
    (loop with max-d = (isqrt n)
      for d = 2 then (if (evenp d) (+ d 1) (+ d 2)) do
      (cond ((> d max-d) (return (list n))) ; n is prime
        ((zerop (rem n d)) (return (cons d (factors (truncate n d)))))))))
