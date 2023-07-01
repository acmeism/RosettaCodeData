(defparameter *my-proc*
  (sb-ext:run-program "mplayer" (list "/path/to/groovy/tune")
                      :search t :output :stream :wait nil))
(read-line (sb-ext:process-output *my-proc*) nil)
