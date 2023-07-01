(defvar *initial_data*
  (list
    (list "jsmith" "x" 1001 1000
      (list "Joe Smith" "Room 1007" "(234)555-8917" "(234)555-0077" "jsmith@rosettacode.org")
      "/home/jsmith" "/bin/bash")
    (list "jdoe" "x" 1002 1000
      (list "Jane Doe" "Room 1004" "(234)555-8914" "(234)555-0044" "jdoe@rosettacode.org")
      "/home/jdoe" "/bin/bash")))

(defvar *insert*
  (list "xyz" "x" 1003 1000
    (list "X Yz" "Room 1003" "(234)555-8913" "(234)555-0033" "xyz@rosettacode.org")
    "/home/xyz" "/bin/bash"))


(defun serialize (record delim)
  (string-right-trim delim ;; Remove trailing delimiter
    (reduce (lambda (a b)
      (typecase b
        (list (concatenate 'string a (serialize b ",") delim))
        (t (concatenate 'string a
          (typecase b
            (integer (write-to-string b))
            (t b))
          delim))))
  record :initial-value "")))
			

(defun main ()
  ;; Write initial values to file
  (with-open-file (stream "./passwd"
                  :direction :output
                  :if-exists :supersede
                  :if-does-not-exist :create)
    (loop for x in *initial_data* do
      (format stream (concatenate 'string (serialize x ":") "~%"))))

  ;; Reopen file, append insert value
  (with-open-file (stream "./passwd"
                  :direction :output
                  :if-exists :append)
    (format stream (concatenate 'string (serialize *insert* ":") "~%")))

  ;; Reopen file, search for new record
  (with-open-file (stream "./passwd")
    (when stream
      (loop for line = (read-line stream nil)
        while line do
          (if (search "xyz" line)
            (format t "Appended record: ~a~%" line))))))

(main)
