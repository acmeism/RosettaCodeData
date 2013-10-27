(ql:quickload (list :usocket))
(defpackage :echo (:use :cl :usocket))
(in-package :echo)

(defun read-all (stream)
  (loop for char = (read-char-no-hang stream nil :eof)
     until (or (null char) (eq char :eof)) collect char into msg
     finally (return (values msg char))))

(defun echo-server (port &optional (log-stream *standard-output*))
  (let ((connections (list (socket-listen "127.0.0.1" port :reuse-address t))))
    (unwind-protect
	 (loop (loop for ready in (wait-for-input connections :ready-only t)
		  do (if (typep ready 'stream-server-usocket)
			 (push (socket-accept ready) connections)
			 (let* ((stream (socket-stream ready))
				(msg (concatenate 'string "You said: " (read-all stream))))
			   (format log-stream "Got message...~%")
			   (write-string msg stream)
			   (socket-close ready)
			   (setf connections (remove ready connections))))))
      (loop for c in connections do (loop while (socket-close c))))))

(echo-server 12321)
