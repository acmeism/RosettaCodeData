;; Solution 1:
(defun fizzbuzz ()
  (loop for x from 1 to 100 do
    (princ (cond ((zerop (mod x 15)) "FizzBuzz")
                 ((zerop (mod x 3))  "Fizz")
                 ((zerop (mod x 5))  "Buzz")
                 (t                  x)))
    (terpri)))

;; Solution 2:
(defun fizzbuzz ()
  (loop for x from 1 to 100 do
    (format t "~&~{~A~}"
      (or (append (when (zerop (mod x 3)) '("Fizz"))
                  (when (zerop (mod x 5)) '("Buzz")))
          (list x)))))

;; Solution 3:
(defun fizzbuzz ()
  (loop for n from 1 to 100
     do (format t "~&~[~[FizzBuzz~:;Fizz~]~*~:;~[Buzz~*~:;~D~]~]~%"
                (mod n 3) (mod n 5) n)))
