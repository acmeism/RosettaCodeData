(defun loop (m)
  (receive
    (`#(,caller ,n)
     (let ((sum (+ m n)))
       (! caller sum)
       (loop sum)))))

(defun accum (m)
  (let ((loop-pid (spawn (lambda () (loop m)))))
    (lambda (n)
      (! loop-pid `#(,(self) ,n))
      (receive
        (sum sum)))))
