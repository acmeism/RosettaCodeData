(with-open-file (stream (make-pathname :name "input.txt")
                 :direction :input
                 :if-does-not-exist nil)
  (print (if stream (file-length stream) 0)))

(with-open-file (stream (make-pathname :directory '(:absolute "") :name "input.txt")
                 :direction :input
                 :if-does-not-exist nil)
  (print (if stream (file-length stream) 0)))
