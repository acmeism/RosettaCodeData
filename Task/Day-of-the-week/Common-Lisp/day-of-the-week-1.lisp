(loop for year from 2008 upto 2121
   when (= 6 (multiple-value-bind
                   (second minute hour date month year day-of-week dst-p tz)
                 (decode-universal-time (encode-universal-time 0 0 0 25 12 year))
               (declare (ignore second minute hour date month year dst-p tz))
               day-of-week))
     collect year)
