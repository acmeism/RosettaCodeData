(defun change-base (number input-base output-base)
  (format nil "~vr" output-base (parse-integer number :radix input-base)))
