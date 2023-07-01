(defun palindromep (str)
  (string-equal str (reverse str)) )

(loop
  for i from 0
  with results = 0
  until (>= results 6)
  do
    (when (and (palindromep (format nil "~B" i))
               (palindromep (format nil "~3R" i)) )
      (format t "n:~a~:*  [2]:~B~:*  [3]:~3R~%" i)
      (incf results) ))
