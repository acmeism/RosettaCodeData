; Display date at Time Zero in UTC.
(printf "~s~%" (time-utc->date (make-time 'time-utc 0 0) 0))
