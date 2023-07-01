(with-open-file (str "filename.txt"
                     :direction :output
                     :if-exists :supersede
                     :if-does-not-exist :create)
  (format str "File content...~%"))
