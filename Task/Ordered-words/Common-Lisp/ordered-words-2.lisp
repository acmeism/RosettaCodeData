(defun orderedp (word)
  (apply #'char<= (coerce word 'list)))

(let* ((words (uiop:read-file-lines "unixdict.txt"))
	   (ordered (delete-if-not #'orderedp words))
	   (maxlen (apply #'max (mapcar #'length ordered)))
	   (result (delete-if-not (lambda (l) (= l maxlen)) ordered :key #'length)))
  (format t "~{~A~^, ~}" result))
