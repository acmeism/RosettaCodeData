(ql:quickload :usocket)
(defpackage :hello-web-manual (:use :cl :usocket))
(in-package :hello-web-manual)

(defun crlf (&optional (stream *standard-output*))
  (write-char #\return stream)
  (write-char #\linefeed stream)
  (values))

(defun ln (string &optional (stream *standard-output*))
  (write-string string stream)
  (crlf stream))

(defun read-all (stream)
  (loop for char = (read-char-no-hang stream nil :eof)
     until (or (null char) (eq char :eof)) collect char into msg
     finally (return (values msg char))))

(defun serve (port &optional (log-stream *standard-output*))
  (let ((connections (list (socket-listen "127.0.0.1" port :reuse-address t))))
    (unwind-protect
	 (loop (loop for ready in (wait-for-input connections :ready-only t)
		  do (if (typep ready 'stream-server-usocket)
			 (push (socket-accept ready) connections)
			 (let* ((stream (socket-stream ready)))
			   (read-all stream)
			   (format log-stream "Got message...~%")
			   (mapc (lambda (line) (ln line stream))
				 (list "HTTP/1.1 200 OK"
				       "Content-Type: text/plain; charset=UTF-8"
				       ""
				       "Hello world!"))
			   (socket-close ready)
			   (setf connections (remove ready connections))))))
      (loop for c in connections do (loop while (socket-close c))))))

(serve 8080)
