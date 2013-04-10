(defpackage :echo
  (:use :cl :usocket :cl-actors)
  (:import-from :cl-actors #:self))
(in-package :echo)

(defun read-line-no-hang (stream)
  "Reads a line from stream. Returns a partial line rather than hanging."
  (apply #'values
	 (loop for char = (read-char-no-hang stream nil :eof)
	       until (or (null char) (eq :eof char) (char= #\newline char))
	       collect char into str
	       finally (return (list (when str (coerce str 'string)) char)))))

(defactor tcp-server (server handler connections) (message)
  (loop for ready in (wait-for-input (cons server connections) :ready-only t)
	do (if (typep ready 'stream-server-usocket)
	       (push (socket-accept server) connections)
	       (multiple-value-bind (line last-char) (read-line-no-hang (socket-stream ready))
		 (when (eq last-char :eof)
		   (delete ready connections)
		   (socket-close ready))
		 (send handler ready line))))
  (send self nil)
  next)

(defactor echo-handler (stream) (socket input)
  (format stream "~a~%" input)
  (format (socket-stream socket) input)
  next)

(defparameter +port+ 12321)
(defparameter *handler* (echo-handler :stream *standard-input*)
  "Accepts and deals with socket messages.")
(defparameter *server*
  (tcp-server :server (socket-listen "127.0.0.1" +port+)
	      :handler *handler*)
  "Listens on the specified address+port. Passes socket input to specified handler.")
(send *server* :ping) ;; get the server started
