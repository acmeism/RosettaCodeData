(defpackage :rosetta-code/modular-arithmetic
  (:use :cl))

(in-package :rosetta-code/modular-arithmetic)

(defparameter *modulus* nil)

(defun make-modular (op)
  (lambda (&rest args)
    (let ((result (apply op args)))
      (if *modulus*
          (mod result *modulus*)
          result))))

(let ((ops '(+ expt))) ; add more operators as you need
  (shadow ops)
  (dolist (op ops)
    (setf (symbol-function (find-symbol (symbol-name op)))
          (make-modular (symbol-function (find-symbol (symbol-name op) :cl))))))

(defun f (x)
  (+ (expt x 100) x 1))

(format t "No modulus: f(~a) = ~a~%" 10 (f 10))
(format t "Modulus 13: f(~a) = ~a~%" 10 (let ((*modulus* 13)) (f 10)))
