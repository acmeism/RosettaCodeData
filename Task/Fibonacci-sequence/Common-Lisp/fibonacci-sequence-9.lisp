(defun fibo (n)
  (cond ((< n 0) nil)
        ((< n 2) n)
        (t (let ((leo '(1 0)))
             (loop for i from 2 upto n do
               (setf leo (cons (+ (first leo)
                                  (second leo))
                               leo))
               finally (return (first leo)))))))
