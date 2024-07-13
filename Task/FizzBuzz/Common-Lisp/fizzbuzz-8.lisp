(defun range (min max)
  (loop
    :for x :from min :to max
    :collect x))

(defun fizzbuzz ()
  (map 'nil #'(lambda (n)
                (princ
                  (cond
                    ((zerop (mod n 15)) "FizzBuzz!")
                    ((zerop (mod n 5)) "Buzz!")
                    ((zerop (mod n 3)) "Fizz!")
                    (t n))
                  (terpri)))
            (range 1 100)))
