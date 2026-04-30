(require 'calendar)

(defun last-sunday (year)
  "Print the last Sunday in each month of year"
  (mapcar (lambda (month)
    (let*
      ((days (number-sequence 1 (calendar-last-day-of-month month year)))
       (mdy (mapcar (lambda (x) (list month x year)) days))
       (weekdays (mapcar #'calendar-day-of-week mdy))
       (lastsunday (1+ (cl-position 0 weekdays :from-end t))))
      (insert (format "%i-%02i-%02i \n" year month lastsunday))))
    (number-sequence 1 12)))

(last-sunday 2013)
