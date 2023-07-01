(let ((pid (sb-posix:fork)))
  (cond
   ((zerop pid) (write-line "This is the new process."))
   ((plusp pid) (write-line "This is the original process."))
   (t           (error "Something went wrong while forking."))))
