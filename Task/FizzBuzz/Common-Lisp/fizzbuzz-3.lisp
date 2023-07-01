(defun fizzbuzz ()
  (loop for n from 1 to 100
     do (format t "~&~[~[FizzBuzz~:;Fizz~]~*~:;~[Buzz~*~:;~D~]~]~%"
                (mod n 3) (mod n 5) n)))
