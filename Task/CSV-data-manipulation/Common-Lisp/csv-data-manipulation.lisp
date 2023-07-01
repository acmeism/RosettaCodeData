(defun csvfile-to-nested-list (filename delim-char)
    "Reads the csv to a nested list, where each sublist represents a line."
  (with-open-file (input filename)
    (loop :for line := (read-line input nil) :while line
          :collect (read-from-string
                    (substitute #\SPACE delim-char
                                (format nil "(~a)~%" line))))))

(defun sublist-sum-list (nested-list)
  "Return a list with the sum of each list of numbers in a nested list."
  (mapcar (lambda (l) (if (every #'numberp l)
                          (reduce #'+ l) nil))
          nested-list))

(defun append-each-sublist (nested-list1 nested-list2)
  "Horizontally append the sublists in two nested lists. Used to add columns."
  (mapcar #'append nested-list1 nested-list2))

(defun nested-list-to-csv (nested-list delim-string)
  "Converts the nested list back into a csv-formatted string."
  (format nil (concatenate 'string "~{~{~2,'0d" delim-string "~}~%~}")
          nested-list))

(defun main ()
  (let* ((csvfile-path #p"projekte/common-lisp/example_comma_csv.txt")
         (result-path #p"results.txt")
         (data-list (csvfile-to-nested-list csvfile-path #\,))
         (list-of-sums (sublist-sum-list data-list))
         (result-header "C1,C2,C3,C4,C5,SUM"))

    (setf data-list    ; add list of sums as additional column
          (rest    ; remove old header
           (append-each-sublist data-list
                                (mapcar #'list list-of-sums))))
    ;; write to output-file
    (with-open-file (output result-path :direction :output :if-exists :supersede)
      (format output "~a~%~a"
              result-header (nested-list-to-csv data-list ",")))))
(main)
