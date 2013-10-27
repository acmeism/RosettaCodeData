(defun fizzbuzz ()
  (loop for x from 1 to 100 do
    (format t "~&~{~A~}"
      (or (append (when (zerop (mod x 3)) '("Fizz"))
                  (when (zerop (mod x 5)) '("Buzz")))
          (list x)))))
