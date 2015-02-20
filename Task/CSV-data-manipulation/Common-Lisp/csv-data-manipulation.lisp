(defun csv_to_nested_list (filename seperator)
  "Reads the csv to a nested lisp list, where each sublist represents a line.
Each line is read in as a string, the commas are substituted by spaces and
parantheses are added to the beginning and the end. Then the string can be interpreted by the
reader as an actual lisp list. A nested lisp containing all sub-lists (lines) is returned.
First line is assumed to be a comment (as no comment syntax is specified)."
  (let ((list nil))
    (with-open-file (input filename)
      (setf list
	    (loop for line = (read-line input nil)
	       while line collect (read-from-string
				   (substitute #\Tab #\, (format nil "(~a)~%" line)))))
      ;; throw away first line, which is assumed to be a comment
      (cdr list))))

(defun calc_sums (nested_list)
  "Return a list of sums of each sub-list in a nested list."
  (loop for sublist in nested_list collect (apply #'+ sublist)))

(defun list_to_csv (nested_list)
  "Converts the nested list back into a csv-formatted string."
  (substitute #\, #\
	      (substitute #\newline #\)
			  (remove #\((string-trim ")(" (format nil "~A" nested_list))))))
;; main program
;; prints the results as lisp lists and as csv
(let ((nested_list (csv_to_nested_list "example_comma_csv.txt" #\,))
      (sum_list nil)
      (comment "#C1,C2,C3,C4,C5,SUM"))
  (setf sum_list (loop
		    for list in nested_list
		    for sum in (calc_sums nested_list)
		    collect (append list (list sum))))
  (format t "~A~%~%" sum_list) ;; print nested list in lisp representation
  (format t "~A~%~A~%" comment (list_to_csv sum_list))) ;; print it again as csv
