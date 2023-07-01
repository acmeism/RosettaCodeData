(defun egyptian-division (dividend divisor)
  (let* ((doublings (reverse (loop for n = divisor then (* 2 n)
                                until (> n dividend)
                                collect n)))
         (powers-of-two (reverse (loop for n = 1 then (* 2 n)
                                    repeat (length doublings)
                                    collect n))))
    (loop
       for d in doublings
       for p in powers-of-two
       with accumulator = 0
       with answer = 0
       finally (return (values answer (- dividend (* answer divisor))))
       when (<= (+ accumulator d) dividend)
       do (incf answer p)
          (incf accumulator d))))
