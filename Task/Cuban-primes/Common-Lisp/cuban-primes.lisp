;;; Show the first 200 and the 100,000th cuban prime.
;;; Cuban primes are the difference of 2 consecutive cubes.

(defun primep (n)
  (cond ((< n 4) t)
        ((evenp n) nil)
        ((zerop (mod n 3)) nil)
        (t (loop for i from 5 upto (isqrt n) by 6
              when (or
                     (zerop (mod n i))
                     (zerop (mod n (+ i 2))))
                return nil
              finally (return t)))))

(defun cube (n) (* n n n))

(defun cuban (n)
  (loop for i from 1
        for j from 2
        for cube-diff = (- (cube j) (cube i))
          when (primep cube-diff)
            collect cube-diff into cuban-primes
            and count i into counter
          when (= counter n)
            return cuban-primes))


(format t "~a~%" "1st to 200th cuban prime numbers:")
(format t
    "~{~<~%~,120:;~10:d ~>~}~%"
    (cuban 200))


(format t "~%100,000th cuban prime number = ~:d"
    (car (last (cuban 100000))))

(princ #\newline)
