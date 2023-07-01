(define-condition unexpected-odd-number (error)
  ((number :reader number :initarg :number))
  (:report (lambda (condition stream)
             (format stream "Unexpected odd number: ~w."
                     (number condition)))))

(defun get-number (&aux (n (random 100)))
  (if (not (oddp n)) n
    (error 'unexpected-odd-number :number n)))

(defun get-even-number ()
  (handler-case (get-number)
    (unexpected-odd-number (condition)
      (1+ (number condition)))))
