(defun multiplier (f g)
  #'(lambda (x) (* f g x)))

(let* ((x 2.0)
       (xi 0.5)
       (y 4.0)
       (yi 0.25)
       (z (+ x y))
       (zi (/ 1.0 (+ x y)))
       (numbers (list x y z))
       (inverses (list xi yi zi)))
  (loop with value = 0.5
        for number in numbers
        for inverse in inverses
        for multiplier = (multiplier number inverse)
        do (format t "~&(~A * ~A)(~A) = ~A~%"
                   number
                   inverse
                   value
                   (funcall multiplier value))))
