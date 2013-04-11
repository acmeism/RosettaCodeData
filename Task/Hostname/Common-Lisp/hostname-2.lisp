(cffi:defcfun ("gethostname" c-gethostname) :int
  (buf :pointer) (len :unsigned-long))

(defun get-hostname ()
  (cffi:with-foreign-object (buf :char 256)
    (unless (zerop (c-gethostname buf 256))
      (error "Can't get hostname"))
    (values (cffi:foreign-string-to-lisp buf))))
