(with-open-file
    (stream
        (make-pathname :directory '(:absolute "") :name "output.txt")
        :direction :output))
