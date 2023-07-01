(defun random-int32 ()
  (with-open-file (s "/dev/random" :element-type '(unsigned-byte 32))
    (read-byte s)))
