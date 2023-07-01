(defun repeat-string (n string
                     &aux
                     (len (length string))
                     (result (make-string (* n len)
                                          :element-type (array-element-type string))))
  (loop repeat n
        for i from 0 by len
        do (setf (subseq result i (+ i len)) string))
  result)
