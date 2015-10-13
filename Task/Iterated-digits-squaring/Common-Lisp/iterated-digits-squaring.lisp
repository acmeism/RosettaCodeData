(defun square (number)
  (expt number 2))

(defun list-digits (number)
  "Return the `number' as a list of its digits."
  (loop
    :for (rest digit) := (multiple-value-list (truncate number 10))
                      :then (multiple-value-list (truncate rest 10))
    :collect digit
    :until (zerop rest)))

(defun next (number)
  (loop
    :for digit :in (list-digits number)
    :sum (square digit)))

(defun chain-end (number)
  "Return the ending number after summing the squaring of the digits of
`number'.  Either 1 or 89."
  (loop
    :for next := (next number) :then (next next)
    :until (or (eql next 1)
               (eql next 89))
    :finally (return next)))

(time
 (loop
   :with count := 0
   :for candidate :from 1 :upto 100000000
   :do (when (eql 89 (chain-end candidate))
         (incf count))
   :finally (return count)))
