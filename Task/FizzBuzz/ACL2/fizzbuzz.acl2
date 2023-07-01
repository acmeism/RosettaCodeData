(defun fizzbuzz-r (i)
   (declare (xargs :measure (nfix (- 100 i))))
   (prog2$
    (cond ((= (mod i 15) 0) (cw "FizzBuzz~%"))
          ((= (mod i 5) 0) (cw "Buzz~%"))
          ((= (mod i 3) 0) (cw "Fizz~%"))
          (t (cw "~x0~%" i)))
    (if (zp (- 100 i))
        nil
        (fizzbuzz-r (1+ i)))))

(defun fizzbuzz () (fizzbuzz-r 1))
