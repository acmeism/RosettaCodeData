(defun decimal-to-base-n (number &key (base 16))
  (format nil (format nil "~~~dr" base) number))

(defun base-n-to-decimal (number &key (base 16))
  (read-from-string (format nil "#~dr~d" base number)))
