(ql:quickload :cffi)

(defconstant +SIGINT+ 2)

(defmacro set-signal-handler (signo &body body)
  (let ((handler (gensym "HANDLER")))
    `(progn
       (cffi:defcallback ,handler :void ((signo :int))
         (declare (ignore signo))
         ,@body)
       (cffi:foreign-funcall "signal" :int ,signo :pointer (cffi:callback ,handler)))))

(defvar *initial* (get-internal-real-time))

(set-signal-handler +SIGINT+
  (format t "Ran for ~a seconds~&" (/ (- (get-internal-real-time) *initial*) internal-time-units-per-second))
  (quit))

(let ((i 0))
  (loop do
    (format t "~a~&" (incf i))
    (sleep 0.5)))
