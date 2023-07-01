(defun sum-of-digits (n)
 "Return the sum of the digits of a number"
  (do* ((sum 0 (+ sum rem))
        rem )
       ((zerop n) sum)
    (multiple-value-setq (n rem) (floor n 10)) ))

(defun additive-primep (n)
  (and (primep n) (primep (sum-of-digits n))) )


; To test if a number is prime we can use a number of different methods. Here I use Wilson's Theorem (see Primality by Wilson's theorem):

(defun primep (n)
  (unless (zerop n)
    (zerop (mod (1+ (factorial (1- n))) n)) ))

(defun factorial (n)
  (if (< n 2) 1 (* n (factorial (1- n)))) )
