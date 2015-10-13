(defun digit-sum (n)
  (apply '+
        (mapcar 'string-to-number
                (cdr (butlast (split-string (number-to-string n) "") )))))

(insert (format "%d\n" (digit-sum 1234) ))
