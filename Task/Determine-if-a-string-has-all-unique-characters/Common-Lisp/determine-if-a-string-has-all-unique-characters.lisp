;; * Loading the iterate library
(eval-when (:compile-toplevel :load-toplevel)
  (ql:quickload '("iterate")))

;; * The package definition
(defpackage :unique-string
  (:use :common-lisp :iterate))
(in-package :unique-string)

;; * The test strings
(defparameter test-strings
  '("" "." "abcABC" "XYZ ZYX" "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"))

;; * The function
(defun unique-string (string)
  "Returns T if STRING has all unique characters."
  (iter
    (with hash = (make-hash-table :test #'equal))
    (with len = (length string))
    (with result = T)
    (for char in-string string)
    (for pos  from 0)
    (initially (format t "String ~a of length ~D~%" string len))
    (if #1=(gethash char hash)
        ;; The character was seen before
        (progn
          (format t
                  " --> Non-unique character ~c #X~X found at position ~D,
                  before ~D ~%" char (char-code char) pos #1#)
          (setf result nil))
        ;; The character was not seen before, saving its position
        (setf #1# pos))
    (finally (when result
               (format t " --> All characters are unique~%"))
             (return result))))

(mapcar #'unique-string test-strings)
