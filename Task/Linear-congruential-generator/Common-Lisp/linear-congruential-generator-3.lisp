(format t "Count:~15tBSD:~30tMS:~%~{~{~a~15t~a~30t~a~%~}~}"
        (loop for i from 0 upto 5 collect
             (list i
                   (linear-random 0 :times i)
                   (linear-random 0 :times i :multiplier 214013 :adder 2531011 :max 32767 :divisor (expt 2 16)))))
