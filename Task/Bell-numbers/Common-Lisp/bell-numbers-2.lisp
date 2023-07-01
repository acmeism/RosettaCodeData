;;; Compute bell numbers analytically

;; Compute the factorial
(defun fact (n)
    (cond ((< n 0) nil)
          ((< n 2) 1)
          (t (* n (fact (1- n))))))

;; Compute the binomial coefficient (n choose k)
(defun binomial (n k)
    (loop for i from 1 upto k
        collect (/ (- (1+ n) i) i) into lst
        finally (return (reduce #'* lst))))

;; Compute the Stirling number of the second kind
(defun stirling (n k)
    (/
      (loop for i upto k summing
        (* (expt -1 i) (binomial k i) (expt (- k i) n)))
      (fact k)))

;; Compute the Bell number
(defun bell (n)
    (loop for k upto n summing (stirling n k)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Printing section
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *numbers-to-print*
    (append
      (loop for i upto 19 collect i)
      '(49 50)))


(defun print-bell-number (index bell-number)
    (format t "B_~d (~:r Bell number) = ~:d~%"
        index (1+ index) bell-number))

;; Final invocation
(loop for n in *numbers-to-print* do
    (print-bell-number n (bell n)))
