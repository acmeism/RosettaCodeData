(defun semordnilaps (word-list)
  (let ((word-map (make-hash-table :test 'equal)))
    (loop for word in word-list do
         (setf (gethash word word-map) t))
    (loop for word in word-list
       for rword = (reverse word)
       when (and (string< word rword) (gethash rword word-map))
       collect (cons word rword))))

(defun main ()
  (let ((words
         (semordnilaps
          (with-open-file (s "unixdict.txt")
            (loop for line = (read-line s nil nil)
               until (null line)
               collect (string-right-trim #(#\space #\return #\newline) line))))))
    (format t "Found pairs: ~D" (length words))
    (loop for x from 1 to 5
       for word in words
       do (print word)))
  (values))
