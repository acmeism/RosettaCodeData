(defun fix-time-string (calendar-string)
  "If CALENDAR-STRING has no space between time and am/a.m./pm/p.m., add a space.
  Return string with space between time and am/a.m./pm/p.m."
  (replace-regexp-in-string "\\([[:digit:]]\\)\\([ap]\\)" "\\1 \\2" calendar-string))

(defun is-pm (calendar-string)
  "Test if CALENDAR-STRING has PM/pm/P.M/p.m in it."
  (string-match-p "[Pp][.]?[Mm]" calendar-string))

(defun is-hour-1-to-11 (a-calendar-list)
  "Test if hour in A-CALENDAR-LIST is between 1 and 11."
  (let ((hour-value))
    (setq hour-value (nth 2 a-calendar-list))
    (and (>= hour-value 1) (<= hour-value 11))))

(defun adjust-if-pm (time-as-string)
  "If TIME-AS-STRING includes pm/PM, and hour is 1 to 11, add 12 hours.
   Return CALENDAR-LIST modified if date is pm and hour is 1-11; otherwise
   return CALENDAR-LIST of original TIME-AS-STRING."
  (let ((calendar-list))
    (setq calendar-list (parse-time-string time-as-string))
              (if (and (is-pm time-as-string) (is-hour-1-to-11 calendar-list))
                  (decoded-time-add calendar-list (make-decoded-time :hour 12))
                calendar-list)))

(defun add-hours (calendar-list number-of-hours)
  "Add NUMBER-OF-HOURS to CALENDAR-LIST."
  (decoded-time-add calendar-list (make-decoded-time :hour number-of-hours)))

(defun calc-future-time (string-calendar-date number-of-hours-in-future)
  "Calculate future time by adding NUMBER-OF-HOURS-IN-FUTURE to STRING-CALENDAR-DATE ."
  (let ((fixed-calendar-string)
        (24-hour-calendar-list)
        (calendar-list-future-time)
        (coded-future-time))
    (setq fixed-calendar-string (fix-time-string string-calendar-date))
    (setq 24-hour-calendar-list (adjust-if-pm fixed-calendar-string))
    (setq calendar-list-future-time (add-hours 24-hour-calendar-list number-of-hours-in-future))
    (setq coded-future-time (encode-time calendar-list-future-time))
    (format-time-string "%B %e %Y %R %p %Z" coded-future-time)))
