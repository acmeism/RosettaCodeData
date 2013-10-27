(defvar *clients* '()
    "This is a list of (socket :input status) which is used with
`socket:socket-status' to test for data ready on a socket.")

(defun echo-server (port)
    "Listen on `port' for new client connections and for data arriving on
any existing client connections"
    (let ((server (socket:socket-server port)))
        (format t "Echo service listening on port ~a:~d~%"
            (socket:socket-server-host server)
            (socket:socket-server-port server))
        (unwind-protect
            (loop
                (when (socket:socket-status server 0 1)
                    (echo-accept-client (socket:socket-accept server
                                            :external-format :dos
                                            :buffered t)))
                (when *clients*
                    (socket:socket-status *clients* 0 1)
                    (mapcar #'(lambda (client)
                                  (when (eq :input (cddr client))
                                      (echo-service-client (car client)))
                                  (when (eq :eof (cddr client))
                                      (echo-close-client (car client)))) *clients*)))
            (socket-server-close server))))

(defun echo-accept-client (socket)
    "Accept a new client connection and add it to the watch list."
    (multiple-value-bind
        (host port) (socket:socket-stream-peer socket)
        (format t "Connect from ~a:~d~%" host port))
    (push (list socket :input nil) *clients*))

(defun echo-service-client (socket)
    (let ((line (read-line socket nil nil)))
        (princ line socket)
        (finish-output socket)))

(defun echo-close-client (socket)
    "Close a client connection and remove it from the watch list."
    (multiple-value-bind
        (host port) (socket:socket-stream-peer socket)
        (format t "Closing connection from ~a:~d~%" host port))
    (close socket)
    (setq *clients* (remove socket *clients* :key #'car)))

(echo-server 12321)
