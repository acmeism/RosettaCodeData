(defconstant *day-names*
    #("Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday"))
(defconstant *month-names*
    #(nil "January" "February" "March" "April" "May" "June" "July"
      "August" "September" "October" "November" "December"))

(multiple-value-bind (sec min hour date month year day daylight-p zone) (get-decoded-time)
    (format t "~4d-~2,'0d-~2,'0d~%" year month date)
    (format t "~a, ~a ~d, ~4d~%"
        (aref *day-names* day) (aref *month-names* month) date year))
