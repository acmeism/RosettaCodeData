(define my-date (string->date "March 7 2009 7:30 pm EST"))
    → Sun Mar 08 2009 01:30:00 GMT+0100 (CET)

(date-add! my-date (* 12 3600))
    → Sun Mar 08 2009 13:30:00 GMT+0100 (CET)
(string->date my-date)

(date->string my-date)
    → "8/3/2009 13:30:00" ;; human localized, Paris time.
