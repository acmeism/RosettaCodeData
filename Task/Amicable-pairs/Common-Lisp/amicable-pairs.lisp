(let ((cache (make-hash-table)))
  (defun sum-proper-divisors (n)
    (or (gethash n cache)
        (setf (gethash n cache)
              (loop for x from 1 to (/ n 2)
                    when (zerop (rem n x))
                      sum x)))))

(defun amicable-pairs-up-to (n)
  (loop for x from 1 to n
        for sum-divs = (sum-proper-divisors x)
        when (and (< x sum-divs) (= x (sum-proper-divisors sum-divs)))
          collect (list x sum-divs)))

(amicable-pairs-up-to 20000)
