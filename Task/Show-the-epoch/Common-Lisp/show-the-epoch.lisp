(multiple-value-bind (second minute hour day month year) (decode-universal-time 0 0)
 	  (format t "~4,'0D-~2,'0D-~2,'0D ~2,'0D:~2,'0D:~2,'0D" year month day hour minute second))
