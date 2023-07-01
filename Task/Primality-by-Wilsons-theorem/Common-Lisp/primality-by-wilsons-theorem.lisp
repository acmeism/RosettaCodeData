(defun factorial (n)
  (if (< n 2) 1 (* n (factorial (1- n)))) )


(defun primep (n)
 "Primality test using Wilson's Theorem"
  (unless (zerop n)
    (zerop (mod (1+ (factorial (1- n))) n)) ))
