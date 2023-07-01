CL-USER> (let* ((string "Hello World!")
                (c-string (cffi:foreign-funcall "strdup" :string string :pointer)))
           (unwind-protect (write-line (cffi:foreign-string-to-lisp c-string))
             (cffi:foreign-funcall "free" :pointer c-string :void))
           (values))
Hello World!
; No value
