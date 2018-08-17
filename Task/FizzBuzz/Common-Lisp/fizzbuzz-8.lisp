;; Project : FizzBuzz

(defun fizzbuzz (&optional n)
          (let ((n (or n 1)))
          (if (> n 100)
              nil
              (progn
              (let ((mult-3 (is-mult-p n 3))
              (mult-5 (is-mult-p n 5)))
              (if mult-3
                  (princ "Fizz"))
              (if mult-5
                  (princ "Buzz"))
              (if (not (or mult-3 mult-5))
                  (princ n))
              (princ #\linefeed)
              (fizzbuzz (+ n 1)))))))
(defun is-mult-p (n multiple)
          (= (rem n multiple) 0))
(fizzbuzz 1)
