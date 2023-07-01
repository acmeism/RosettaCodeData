(require 'calendar)

(defun last-friday (year)
  "Print the last Friday in each month of year"
  (mapcar (lambda (month)
    (let*
      ((days (number-sequence 1 (calendar-last-day-of-month month year)))
       (mdy (mapcar (lambda (x) (list month x year)) days))
       (weekdays (mapcar #'calendar-day-of-week mdy))
       (lastfriday (1+ (cl-position 5 weekdays :from-end t))))
      (insert (format "%i-%02i-%02i \n" year month lastfriday))))
    (number-sequence 1 12)))

(last-friday 2012)
