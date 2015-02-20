(defun friday-before (year month day)
 (let*
  ((timestamp (encode-universal-time 0 0 12 day month year))
   (weekday (nth 6 (multiple-value-list (decode-universal-time timestamp))))
   (fri (- timestamp (* (+ (mod (+ weekday 2) 7) 1) 86400))))
    (multiple-value-bind (_ _ _ d m y) (decode-universal-time fri)
     (list y m d))))

(defun last-fridays (year)
  (append (loop for month from 2 to 12 collecting (friday-before year month 1))
          (list (friday-before (1+ year) 1 1))))

(let* ((year (read-from-string (car *args*))))
  (format t "~{~{~a-~2,'0d-~2,'0d~}~%~}" (last-fridays year)))
