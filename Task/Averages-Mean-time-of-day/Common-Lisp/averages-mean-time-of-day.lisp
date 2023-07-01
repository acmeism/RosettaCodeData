;; * Loading the split-sequence library
(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '("split-sequence")))

;; * The package definition
(defpackage :mean-time-of-day
  (:use :common-lisp :iterate :split-sequence))
(in-package :mean-time-of-day)

;; * The data
(defparameter *time-values*
  '("23:00:17" "23:40:20" "00:12:45" "00:17:19"))

(defun time->radian (time)
  "Returns the radian value for TIME given as a STRING like HH:MM:SS. Assuming a
valid input value."
  (destructuring-bind (h m s)
      (mapcar #'parse-integer (split-sequence #\: time))
    (+  (* h (/ PI 12)) (* m (/ PI 12 60)) (* s (/ PI 12 3600)))))

(defun radian->time (radian)
  "Returns the corresponding time as a string like HH:MM:SS for RADIAN."
  (let* ((time (if (plusp radian)
                   (round (/ (* 12 3600 radian) PI))
                   (round (/ (* 12 3600 (+ radian (* 2 PI))) PI))))
         (h (floor time 3600))
         (m (floor (- time (* h 3600)) 60))
         (s (- time (* h 3600) (* m 60))))
    (format nil "~2,'0D:~2,'0D:~2,'0D" h m s)))

(defun make-polar (rho theta)
  "Returns a complex representing the polar coordinates."
  (complex (* rho (cos theta)) (* rho (sin theta))))

(defun mean-time (times)
  "Returns the mean time value within 24h of the list of TIMES given as strings
  HH:MM:SS."
  (radian->time (phase
                 (reduce #'+ (mapcar (lambda (time)
                                       (make-polar 1 (time->radian time))) times)))))
