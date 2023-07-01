; Project : Babbage problem

(setq n 1)
(setq bab2 1)
(loop while (/= bab2 269696)
    do (setq n (+ n 1))
         (setf bab1 (expt n 2))
         (setf bab2 (mod bab1 1000000)))
(format t "~a" "The smallest number whose square ends in 269696 is: ")
(write n)
(terpri)
(format t "~a" "Its square is: ")
(write (* n n))
