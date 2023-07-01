(defun guess-the-number (&optional (max 1000) (min 0))
  (flet ((get-feedback (guess)
           (loop
              initially (format t "I choose ~a.~%" guess)
              for answer = (read)
              if (member answer '(greater lower correct))
              return answer
              else do (write-line "Answer greater, lower, or correct."))))
    (loop
       initially (format t "Think of a number between ~a and ~a.~%" min max)
       for guess  = (floor (+ min max) 2)
       for answer = (get-feedback guess)
       until (eq answer 'correct)
       if (eq answer 'greater) do (setf min guess)
       else do (setf max guess)
       finally (write-line "I got it!"))))
