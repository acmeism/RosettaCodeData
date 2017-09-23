(defun last-sundays (year)
  (loop for month from 1 to 12
        for last-month-p = (= month 12)
        for next-month = (if last-month-p 1 (1+ month))
        for year-of-next-month = (if last-month-p (1+ year) year)
        for 1st-day-next-month = (encode-universal-time 0 0 0 1 next-month year-of-next-month 0)
        for 1st-day-dow = (nth-value 6 (decode-universal-time 1st-day-next-month 0))
        ;; 0: monday, 1: tuesday, ... 6: sunday
        for diff-to-last-sunday = (1+ 1st-day-dow)
        for last-sunday = (- 1st-day-next-month (* diff-to-last-sunday 24 60 60))
        do (multiple-value-bind (second minute hour date month year)
               (decode-universal-time last-sunday 0)
             (declare (ignore second minute hour))
             (format t "~D-~2,'0D-~2,'0D~%" year month date))))

(last-sundays 2013)
