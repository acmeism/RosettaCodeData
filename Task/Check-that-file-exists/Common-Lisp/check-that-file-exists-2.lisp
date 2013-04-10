(if (cl-fad:directory-exists-p (make-pathname :directory '(:relative "docs")))
    (print "rel directory exists")
    (print "rel directory does not exist"))
