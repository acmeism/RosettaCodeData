(require 'calendar)

(defun sunday-p (y)
  "Is Dec 25th a Sunday in this year?"
  (= (calendar-day-of-week (list 12 25 y)) 0))

(defun xmas-sunday (a b)
  "In which years in the range a, b is Dec 25th a Sunday?"
  (seq-filter #'sunday-p (number-sequence a b)))

(print (xmas-sunday 2008 2121))
