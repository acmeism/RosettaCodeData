(ql:quickload '(:stmx :bordeaux-threads))

(defpackage :dining-philosophers
  (:use :cl))

(in-package :dining-philosophers)

(defstruct philosopher
  name
  left-fork
  right-fork)

(defparameter *philosophers* '("Aristotle" "Kant" "Spinoza" "Marx" "Russell"))
(defparameter *eating-max* 5.0)
(defparameter *thinking-max* 5.0)
(defvar *log-lock* (bt:make-lock))
(defvar *running* nil)

(defun print-log (name status)
  (bt:with-lock-held (*log-lock*)
    (format t "~a is ~a~%" name status)))

(defun philosopher-cycle (philosopher)
  "Continously atomically grab and return the left and right forks of the given PHILOSOPHER."
  (with-slots (name left-fork right-fork) philosopher
    (loop while *running*
       do
         (print-log name "hungry")
         (stmx:atomic
          (stmx.util:take left-fork)
          (stmx.util:take right-fork))
         (print-log name "eating")
         (sleep (random *eating-max*))
         (stmx:atomic
          (stmx.util:put left-fork t)
          (stmx.util:put right-fork t))
         (print-log name "thinking")
         (sleep (random *thinking-max*)))))

(defun scenario ()
  (let ((forks (loop repeat (length *philosophers*) collect (stmx.util:tcell t))))
    (setf *running* t)
    (loop for name in *philosophers*
       for left-fork in forks
       for right-fork in (append (cdr forks) (list (car forks)))
       do (let ((philosopher (make-philosopher :name name :left-fork left-fork :right-fork right-fork)))
            (bt:make-thread (lambda () (philosopher-cycle philosopher))
                            :initial-bindings (cons (cons '*standard-output* *standard-output*)
                                                    bt:*default-special-bindings*))))))
