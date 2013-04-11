(defun get-host-name ()
    #+sbcl (machine-instance)
    #+clisp (let ((s (machine-instance))) (subseq s 0 (position #\Space s)))
    #-(or sbcl clisp) (error "get-host-name not implemented"))
