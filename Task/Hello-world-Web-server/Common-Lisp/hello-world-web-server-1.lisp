(ql:quickload :hunchentoot)
(defpackage :hello-web (:use :cl :hunchentoot))
(in-package :hello-web)

(define-easy-handler (hello :uri "/") () "Goodbye, World!")

(defparameter *server* (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 8080)))
