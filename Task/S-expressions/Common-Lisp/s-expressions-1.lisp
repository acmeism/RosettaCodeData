(defun lsquare-reader (stream char)
  (declare (ignore char))
  (read-delimited-list #\] stream t))
(set-macro-character #\[ #'lsquare-reader)               ;;Call the lsquare-reader function when a '[' token is parsed
(set-macro-character #\] (get-macro-character #\) nil))  ;;Do the same thing as ')' when a ']' token is parsed
