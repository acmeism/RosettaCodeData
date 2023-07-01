(defun get-host-name ()
    #+(or sbcl ccl) (machine-instance)
    #+clisp (let ((s (machine-instance))) (subseq s 0 (position #\Space s)))
    #-(or sbcl ccl clisp) (error "get-host-name not implemented"))
