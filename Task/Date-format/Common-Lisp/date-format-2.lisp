(local-time:format-timestring nil (local-time:now) :format '(:year  "-" (:month 2) "-" (:day 2)))
;; => "2019-11-13"
(local-time:format-timestring nil (local-time:now) :format '(:long-weekday ", " :long-month #\space (:day 2) ", " :year))
;; => "Wednesday, November 13, 2019"
