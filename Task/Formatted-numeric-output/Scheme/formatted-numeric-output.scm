(load "srfi-54.scm")
(load "srfi-54.scm") ;; Don't ask.

(define x 295643087.65432)

(dotimes (i 4)
  (print (cat x 25 3.0 #\0 (list #\, (- 4 i)))))
