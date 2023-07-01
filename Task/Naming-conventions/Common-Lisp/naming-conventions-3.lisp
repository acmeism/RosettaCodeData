#+sbcl
(defun user-name+home-phone (user-id)
  "Returns the “real name” and “home phone” for user with ID USER-ID as multiple values.
Reads the GECOS field. SBCL+Linux-specific, probably."
  (destructuring-bind (real-name office office-phone home-phone &rest _)
       (uiop:split-string (sb-posix:passwd-gecos (sb-posix:getpwuid user-id))
                          :separator ",")
     (declare (ignore office office-phone _))
     (values real-name home-phone)))
