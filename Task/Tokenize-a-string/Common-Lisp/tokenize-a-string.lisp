(defun comma-split (string)
  (loop for start = 0 then (1+ finish)
        for finish = (position #\, string :start start)
        collecting (subseq string start finish)
        until (null finish)))

(defun write-with-periods (strings)
  (format t "~{~A~^.~}" strings))
