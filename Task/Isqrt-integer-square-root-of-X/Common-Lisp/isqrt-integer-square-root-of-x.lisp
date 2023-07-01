#!/bin/sh
#|-*- mode:lisp -*-|#
#|
exec ros -Q -- $0 "$@"
|#
(progn ;;init forms
  (ros:ensure-asdf)
  #+quicklisp(ql:quickload '() :silent t)
  )

(defpackage :ros.script.isqrt.3860764029
  (:use :cl))
(in-package :ros.script.isqrt.3860764029)

;;
;; The Rosetta Code integer square root task, in Common Lisp.
;;
;; I translate the tail recursions of the Scheme as regular loops in
;; Common Lisp, although CL compilers most often can optimize tail
;; recursions of the kind. They are not required to, however.
;;
;; As a result, the CL is actually closer to the task's pseudocode
;; than is the Scheme.
;;
;; (The Scheme, by the way, could have been written much as follows,
;; using "set!" where the CL has "setf", and with other such
;; "linguistic" changes.)
;;

(defun find-a-power-of-4-greater-than-x (x)
  (let ((q 1))
    (loop until (< x q)
          do (setf q (* 4 q)))
    q))

(defun isqrt+remainder (x)
  (let ((q (find-a-power-of-4-greater-than-x x))
        (z x)
        (r 0))
    (loop until (= q 1)
          do (progn (setf q (/ q 4))
                    (let ((z1 (- z r q)))
                      (setf r (/ r 2))
                      (when (<= 0 z1)
                        (setf z z1)
                        (setf r (+ r q))))))
    (values r z)))

(defun rosetta_code_isqrt (x)
  (nth-value 0 (isqrt+remainder x)))

(defun main (&rest argv)
  (declare (ignorable argv))
  (format t "isqrt(i) for ~D <= i <= ~D:~2%" 0 65)
  (loop for i from 0 to 64
        do (format t "~D " (isqrt i)))
  (format t "~D~3%" (isqrt 65))
  (format t "isqrt(7**i) for ~D <= i <= ~D, i odd:~2%" 1 73)
  (format t "~2@A ~84@A ~43@A~%" "i" "7**i" "sqrt(7**i)")
  (format t "~A~%" (make-string 131 :initial-element #\-))
  (loop for i from 1 to 73 by 2
        for 7**i = (expt 7 i)
        for root = (rosetta_code_isqrt 7**i)
        do (format t "~2D ~84:D ~43:D~%" i 7**i root)))

;;; vim: set ft=lisp lisp:
