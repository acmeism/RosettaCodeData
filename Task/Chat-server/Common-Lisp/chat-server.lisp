(ql:quickload '(:usocket :simple-actors :bordeaux-threads))

(defpackage :chat-server
  (:use :common-lisp :usocket :simple-actors :bordeaux-threads)
  (:export :accept-connections))

(in-package :chat-server)

(defvar *whitespace* '(#\Space #\Tab #\Page #\Vt #\Newline #\Return))

(defun send-message (users from-user message)
  (loop for (nil . actor) in users
     do (send actor :message from-user message)))

(defun socket-format (socket format-control &rest format-arguments)
  (apply #'format (socket-stream socket) format-control format-arguments)
  (finish-output (socket-stream socket)))

(defvar *log* *standard-output*)

(defmacro log-errors (&body body)
  `(handler-case
       (progn ,@body)
     (t (err)
       (format *log* "Error: ~a" err))))

(defparameter *user-manager*
  (let ((users nil))
    (actor (action &rest args)
       (format *log* "Handling message ~s~%" (cons action args))
       (ecase action
	 (:newuser
	  (destructuring-bind (username session-actor)
	      args
	    (cond ((assoc username users :test #'equalp)
		   (send session-actor :rejected
			 (format nil "Username ~a is already taken. Send /NICK new-nick with a valid name to enter the chat~%" username)))
		  ((equalp username "Server")
		   (send session-actor :rejected
			 (format nil "Server is not a valid username. Send /NICK new-nick with a valid name to enter the chat~%")))
		  (t (send-message users "Server" (format nil "~a has joined the chat." username))
		     (send session-actor :accepted
			   (format nil "Welcome to the Rosetta Code chat server in Common Lisp. ~a users connected.~%"
				   (length users)))
		     (pushnew (cons username session-actor)
			      users
			      :key #'car
			      :test #'equalp)))))
	 (:who
	  (destructuring-bind (username) args
	    (let ((actor (cdr (assoc username users :test #'equalp))))
	      (send actor :message "Server"
		    "Users connected right now:")
	      (loop for (user . nil) in users
		   do (send actor :message "Server" user)))))
	 (:message
	  (apply #'send-message users args))
	 (:dropuser
	  (destructuring-bind (username) args
	    (let ((user-actor (cdr (assoc username users :test #'equalp))))
	      (send user-actor :close)
	      (send user-actor 'stop))
	    (setf users (remove username users
				:key #'car
				:test #'equalp))
	    (send-message users "Server" (format nil "~a has left." username))))))))

(defmacro drop-connection-on-error (&body body)
  `(handler-case (progn ,@body)
     (t (err)
       (format *log* "Error: ~a; Closing connection" err)
       (send self :close)
       (send self 'stop)
       (send *user-manager* :dropuser username))))

(defun parse-command (message)
  (let* ((space-at (position #\Space message))
	 (after-space (and space-at
			   (position-if (lambda (ch)
				     (not (char= ch #\Space)))
					message :start (1+ space-at)))))
    (values (subseq message 0 space-at)
	    (and after-space
		 (string-trim *whitespace*
			      (subseq message after-space))))))

(defun help (socket)
  (socket-format socket "/QUIT to quit, /WHO to list users.~%"))

(defun make-user (username socket)
  (let* ((state :unregistered)
	 (actor
	  (actor (message &rest args)
	    (drop-connection-on-error
	      (ecase message
		(:register
		 (send *user-manager* :newuser username self))
		(:accepted
		 (destructuring-bind (message) args
		   (write-string message (socket-stream socket))
		   (finish-output (socket-stream socket))
		   (setf state :registered)))
		(:rejected
		 (destructuring-bind (message) args
		   (write-string message (socket-stream socket))
		   (finish-output (socket-stream socket))
		   (setf state :unregistered)))
		(:user-typed
		 (destructuring-bind (message) args
		   (when (> (length message) 0)
		     (if (char= (aref message 0) #\/)
			 (multiple-value-bind (cmd arg)
			     (parse-command message)
			   (cond ((equalp cmd "/nick")
				  (ecase state
				    (:unregistered
				     (setf username arg)
				     (send *user-manager* :newuser username self))
				    (:registered
				     (socket-format socket
						    "Can't change your name after successfully registering~%"))))
				 ((equalp cmd "/help")
				  (help socket))
				 ((equalp cmd "/who")
				  (send *user-manager* :who username))
				 ((equalp cmd "/quit")
				  (socket-format socket
					  "Goodbye.~%")
				  (send *user-manager* :dropuser username))
				 (t
				  (socket-format socket
					  "Unknown command~%"))))
			 (send *user-manager* :message username message)))))
		(:message
		 (destructuring-bind (from-user message) args
		   (socket-format socket "<~a> ~a~%" from-user message)))
		(:close
		 (log-errors
		   (close (socket-stream socket)))))))))
    (bt:make-thread (lambda ()
		      (handler-case
			  (loop for line = (read-line (socket-stream socket) nil :eof)
			     do (if (eq line :eof)
				    (send *user-manager* :dropuser username)
				    (send actor :user-typed (remove #\Return line))))
			(t () (send *user-manager* :dropuser username))))
			
		    :name "Reader thread")
    actor))
			

(defun initialize-user (socket)
  (bt:make-thread
   (lambda ()
     (format *log* "Handling new connection ~s" socket)
     (log-errors
       (loop do
	    (socket-format socket "Your name: ")
	    (let ((name (string-trim *whitespace* (read-line (socket-stream socket)))))
	      (format *log* "Registering user ~a" name)
	      (cond ((equalp name "Server")
		     (socket-format socket
				    "Server is not a valid username.~%"))
		    (t (send *user-manager*
			     :newuser name (make-user name socket))
		       (return)))))))
   :name "INITIALIZE-USER"))
	

(defun accept-connections ()
  (let ((accepting-socket (socket-listen "0.0.0.0" 7070)))
    (loop for new-connection = (socket-accept accepting-socket)
	 do (initialize-user new-connection))))

(make-thread #'accept-connections)
