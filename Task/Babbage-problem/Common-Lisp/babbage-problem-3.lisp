;; * The package definition
(defpackage :babbage
  (:use :common-lisp))
(in-package :babbage)

;; * The function
(defun babbage (end)
  "Returns the smallest number whose square ends in END."
  (loop
     :with digits = (ceiling (log end 10))     ; How many digits has end?
     :for num :from (isqrt end)                ; The start number
     :for square = (expt num 2)                ; The square of num
     :for ends = (mod square (expt 10 digits)) ; The last digits
     :until (= ends end)
     :finally
       (format t "The smallest number whose square ends in ~D is: ~D~%" end num)
       (format t "Its square is: ~D~%" square)
       (return num)))
