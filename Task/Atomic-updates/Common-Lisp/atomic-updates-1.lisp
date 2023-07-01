(ql:quickload '(:alexandria :stmx :bordeaux-threads))

(defpackage :atomic-updates
  (:use :cl))

(in-package :atomic-updates)

(defvar *buckets* nil)
(defvar *running* nil)

(defun distribute (ratio a b)
  "Atomically redistribute the values of buckets A and B by RATIO."
  (stmx:atomic
   (let* ((sum (+ (stmx:$ a) (stmx:$ b)))
          (a2 (truncate (* ratio sum))))
     (setf (stmx:$ a) a2)
     (setf (stmx:$ b) (- sum a2)))))

(defun runner (ratio-func)
  "Continously distribute to two different elements in *BUCKETS* with the
value returned from RATIO-FUNC."
  (loop while *running*
     do (let ((a (alexandria:random-elt *buckets*))
              (b (alexandria:random-elt *buckets*)))
          (unless (eq a b)
            (distribute (funcall ratio-func) a b)))))

(defun print-buckets ()
  "Atomically get the bucket values and print out their metrics."
  (let ((buckets (stmx:atomic (map 'vector 'stmx:$ *buckets*))))
    (format t "Buckets: ~a~%Sum: ~a~%" buckets (reduce '+ buckets))))

(defun scenario ()
  (setf *buckets* (coerce (loop repeat 20 collect (stmx:tvar 10)) 'vector))
  (setf *running* t)
  (bt:make-thread (lambda () (runner (constantly 0.5))))
  (bt:make-thread (lambda () (runner (lambda () (random 1.0))))))
