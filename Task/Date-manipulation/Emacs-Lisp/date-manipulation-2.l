(defun fix-time-string (calendar-string)
  "If CALENDAR-STRING has no space between time and a.m./p.m., add a space."
  (replace-regexp-in-string "\\([[:digit:]]\\)\\([ap]\\)" "\\1 \\2" calendar-string))

(defun is-pm (calendar-string)
  "Test if CALENDAR-STRING has PM/pm in it."
  (string-match-p "[Pp][Mm]" time-as-string))

(defun is-hour-1-to-11 (a-calendar-list)
  "Test if hour in A-CALENDAR-LIST is between 1 and 11."
  (let ((hour-value))
    (setq hour-value (nth 2 a-calendar-list))
    (and (>= hour-value 1) (<= hour-value 11))))

(defun adjust-if-pm (time-as-string)
  "If TIME-AS-STRING includes pm/PM, and hour is 1 to 11, add 12 hours.
  Return time as integer of seconds past the epoch."
  (let ((calendar-list)
        (temp-time-stamp)
        (time-stamp-as-integer))
  (setq calendar-list (parse-time-string time-as-string))
  (setq temp-time-stamp (encode-time calendar-list))
  (setq time-stamp-as-integer (time-convert temp-time-stamp 'integer))
    (if (and (is-pm time-as-string) (is-hour-1-to-11 calendar-list))
        (+ time-stamp-as-integer (* 12 60 60))  ; return time + 12 hours, so that hour is 13-23
      time-stamp-as-integer)))                  ; return time unchanged, leaving hour 0-12

(defun add-seconds (start-time-stamp-integer number-of-seconds)
  "Add NUMBER-OF-HOURS to START-TIME-STAMP-INTEGER."
  (+ start-time-stamp-integer number-of-seconds))

(defun calc-future-time (string-calendar-date number-of-seconds-in-future)
  "Calculate future time by adding NUMBER-OF-SECONDS-IN-FUTURE to STRING-CALENDAR-DATE ."
  (let ((fixed-calendar-string)
        (time-stamp-as-integer)
        (coded-current-time)
        (future-time-as-integer))
    (setq fixed-calendar-string (fix-time-string string-calendar-date))
    (setq time-stamp-as-integer (adjust-if-pm fixed-calendar-string))
    (setq future-time-as-integer (add-seconds time-stamp-as-integer number-of-seconds-in-future))
    (format-time-string "%B %e %Y %R %p %Z" future-time-as-integer)))
