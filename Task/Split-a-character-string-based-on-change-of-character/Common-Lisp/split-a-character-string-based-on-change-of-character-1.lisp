(defun split (string)
  (loop :for prev := nil :then c
     :for c :across string
     :do (format t "~:[~;, ~]~c" (and prev (char/= c prev)) c)))

(split "gHHH5YY++///\\")
