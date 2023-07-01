(defun letter-freq (file)
  (with-open-file (stream file)
    (let ((str (make-string (file-length stream)))
	  (arr (make-array 256 :element-type 'integer :initial-element 0)))
      (read-sequence str stream)
      (loop for c across str do (incf (aref arr (char-code c))))
      (loop for c from 32 to 126 for i from 1 do
	    (format t "~c: ~d~a"
		    (code-char c) (aref arr c)
		    (if (zerop (rem i 8)) #\newline #\tab))))))

(letter-freq "test.lisp")
