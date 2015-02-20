(defun add-suffix (number)
  (let* ((suffixes #10("th"  "st"  "nd"  "rd"  "th"))
         (last2 (mod number 100))
         (last-digit (mod number 10))
         (suffix (if (< 10 last2 20)
                   "th"
                   (svref suffixes last-digit))))
    (format nil "~a~a" number suffix)))

(loop for (low high) in '((0 25) (250 265) (1000 1025))
      do (progn
           (format t "~a to ~a: " low high)
           (loop for n from low to high
                 do (format t "~a " (add-suffix n))
                 finally (terpri))))
