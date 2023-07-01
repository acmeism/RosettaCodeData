(ql:quickload :computable-reals :silent t)
(use-package :computable-reals)

(defparameter *iterations* 1000)

(let ((e 1) (f 1))
  (loop for i from 1 to *iterations* doing
     (setq f (* f i))
     (setq e (+ e (/ 1 f))))
  (format t "After ~a iterations, e = " *iterations*)
  (print-r e 2570))
