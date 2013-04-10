(use-package :ffi)

(defmacro def-libc-call-out (name &rest args)
  `(def-call-out ,name
     (:language :stdc)
     #-cygwin(:library "libc.so.6")
     #+cygwin (:library "cygwin1.dll")
     ,@args))

(progn
  (def-libc-call-out errno-location
    #-cygwin (:name "__errno_location")
    #+cygwin (:name "__errno")
    (:arguments)
    (:return-type (c-pointer int)))

  (defun get-errno ()
    (let ((loc (errno-location)))
      (foreign-value loc)))

  (defun set-errno (value)
    (let ((loc (errno-location)))
      (setf (foreign-value loc) value)))

  (defsetf get-errno set-errno)

  (define-symbol-macro errno (get-errno)))
