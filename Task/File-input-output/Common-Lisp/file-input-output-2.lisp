(defconstant +buffer-size+ (expt 2 16))

(with-open-file (in #p"input.txt" :direction :input
                                :element-type '(unsigned-byte 8))
  (with-open-file (out #p"output.txt"
                   :direction :output
                   :element-type (stream-element-type in))
    (loop with buffer = (make-array +buffer-size+
                                    :element-type (stream-element-type in))
          for size = (read-sequence buffer in)
          while (plusp size)
          do (write-sequence buffer out :end size))))
