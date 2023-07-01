(defun van-eck-nm-sequence (n m)
  (loop with ac repeat m
        for i = (position (car ac) (cdr ac)) do
        (push (if i (1+ i) 0) ac)
        finally (return (nthcdr (1- n) (nreverse ac)))))

(format t "The first 10 elements are: ~{~a ~}~%" (van-eck-nm-sequence 1 10))
(format t "The 991-1000th elements are: ~{~a ~}" (van-eck-nm-sequence 991 1000))
