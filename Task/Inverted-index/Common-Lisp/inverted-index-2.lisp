(defparameter *index* (build-index '("file1.txt" "file2.txt" "file3.txt")))
(defparameter *query* "foo bar")
(defparameter *result* (lookup *index* *query*))
(format t "Result for query ~s: ~{~a~^, ~}~%" *query* *result*)
