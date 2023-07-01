(defun remove-lines (filename start num)
  (let ((tmp-filename  (concatenate 'string filename ".tmp"))
	(lines-omitted 0))
    ;; Open a temp file to write the result to
    (with-open-file (out tmp-filename
			 :direction :output
			 :if-exists :supersede
			 :if-does-not-exist :create)
      ;; Open the original file for reading
      (with-open-file (in filename)
	(loop
	   for line = (read-line in nil 'eof)
	   for i from 1
	   until (eql line 'eof)
	   ;; Write the line to temp file if it is not in the omitted range
	   do (if (or (< i start)
		      (>= i (+ start num)))
		(write-line line out)
		(setf lines-omitted (1+ lines-omitted))))))
    ;; Swap in the temp file for the original
    (delete-file filename)
    (rename-file tmp-filename filename)
    ;; Warn if line removal went past the end of the file
    (when (< lines-omitted num)
      (warn "End of file reached with only ~d lines removed." lines-omitted))))
