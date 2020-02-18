(do ((a (random 20) (random 20)))	; Initialize to rand and set new rand on every loop
    ((= a 10) (write a))		; Break condition and last step
  (format t "~a~3T~a~%" a (random 20)))	; On every loop print formated `a' and rand `b'
