(defun count-abc (string)
  (= (count #\a string)
     (count #\b string)
     (count #\c string)))
