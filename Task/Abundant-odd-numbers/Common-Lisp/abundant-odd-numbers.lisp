;; * Loading the external libraries
(eval-when (:compile-toplevel :load-toplevel)
  (ql:quickload '("cl-annot" "iterate" "alexandria")))

;; * The package definition
(defpackage :abundant-numbers
  (:use :common-lisp :cl-annot :iterate)
  (:import-from :alexandria :butlast))
(in-package :abundant-numbers)

(annot:enable-annot-syntax)

;; * Calculating the divisors
@inline
(defun divisors (n)
  "Returns the divisors of N without sorting them."
  @type fixnum n
  (iter
    (for divisor from (isqrt n) downto 1)
    (for (values m rem) = (floor n divisor))
    @type fixnum divisor
    (when (zerop rem)
      (collecting divisor into result)
      (adjoining m into result))
    (finally (return result))))

;; * Calculating the sum of divisors
(defun sum-of-divisors (n)
  "Returns the sum of the proper divisors of N."
  @type fixnum n
  (reduce #'+ (butlast (divisors n))))

;; * Task 1
(time
 (progn
   (format t "   Task 1~%")
   (iter
     (with i = 0)
     (for n from 1 by 2)
     (for sum-of-divisors = (sum-of-divisors n))
     @type fixnum i n sum-of-divisors
     (while (< i 25))
     (when (< n sum-of-divisors)
       (incf i)
       (format t "~5D: ~6D ~7D~%" i n sum-of-divisors)))

   ;; * Task 2
   (format t "~%   Task 2~%")
   (iter
     (with i = 0)
     (until (= i 1000))
     (for n from 1 by 2)
     (for sum-of-divisors = (sum-of-divisors n))
     @type fixnum i n sum-of-divisors
     (when (< n sum-of-divisors)
       (incf i))
     (finally (format t "~5D: ~6D ~7D~%" i n sum-of-divisors)))

   ;; * Task 3
   (format t "~%   Task 3~%")
   (iter
     (for n from (1+ (expt 10 9)) by 2)
     (for sum-of-divisors = (sum-of-divisors n))
     @type fixnum n sum-of-divisors
     (until (< n sum-of-divisors))
     (finally (format t "~D ~D~%~%" n sum-of-divisors)))))
