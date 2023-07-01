(ql:quickload :computable-reals :silent t)
(use-package :computable-reals)
(setq *print-prec* 70)
(defparameter *iterations* 52)

; factorial using computable-reals multiplication op to keep precision
(defun !r (n)
  (let ((p 1))
    (loop for i from 2 to n doing (setq p (*r p i)))
    p))

; the nth integer term
(defun integral (n)
   (let* ((polynomial (+r (*r 532 n n) (*r 126 n) 9))
          (numer  (*r 32 (!r (*r 6 n)) polynomial))
          (denom  (*r 3 (expt-r (!r n) 6))))
    (/r  numer denom)))


; the exponent for 10 in the nth term of the series
(defun power (n) (- 3 (* 6 (1+ n))))

; the nth term of the series
(defun almkvist-giullera (n)
  (/r (integral n) (expt-r 10 (abs (power n)))))

; the sum of the first n terms
(defun almkvist-giullera-sigma (n)
  (let ((s 0))
    (loop for i from 0 to n doing (setq s (+r s (almkvist-giullera i))))
    s))

; the approximation to pi after n terms
(defun almkvist-giullera-pi (n)
  (sqrt-r (/r 1 (almkvist-giullera-sigma n))))

(format t "~A. ~44A~4A ~A~%" "N" "Integral part of Nth term" "×10^" "=Actual value of Nth term")
(loop for i from 0 to 9 doing
  (format t "~&~a. ~44d ~3d " i (integral i) (power i))
  (finish-output *standard-output*)
  (print-r (almkvist-giullera i) 50 nil))

(format t "~%~%Pi after ~a iterations: " *iterations*)
(print-r (almkvist-giullera-pi *iterations*) *print-prec*)
