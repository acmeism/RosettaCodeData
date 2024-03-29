(defconstant +seconds-in-minute* 60)
(defconstant +seconds-in-hour* (* 60 +seconds-in-minute*))
(defconstant +seconds-in-day* (* 24 +seconds-in-hour*))
(defconstant +seconds-in-week* (* 7 +seconds-in-day*))

(defun seconds->duration (seconds)
  (multiple-value-bind (weeks wk-remainder) (floor seconds +seconds-in-week*)
    (multiple-value-bind (days d-remainder) (floor wk-remainder +seconds-in-day*)
      (multiple-value-bind (hours hr-remainder) (floor d-remainder +seconds-in-hour*)
        (multiple-value-bind (minutes secs) (floor hr-remainder +seconds-in-minute*)
          (let ((chunks nil))
            (unless (zerop secs)    (push (format nil "~D sec" secs) chunks))
            (unless (zerop minutes) (push (format nil "~D min" minutes) chunks))
            (unless (zerop hours)   (push (format nil "~D hr" hours) chunks))
            (unless (zerop days)    (push (format nil "~D d" days) chunks))
            (unless (zerop weeks)   (push (format nil "~D wk" weeks) chunks))
            (format t "~{~A~^, ~}~%" chunks)))))))

(seconds->duration 7259)
(seconds->duration 86400)
(seconds->duration 6000000)
