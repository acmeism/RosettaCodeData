#lang racket
(require srfi/19)

(define 12hours (make-time time-duration 0 (* 12 60 60)))

(define (string->time s)
  (define t (date->time-utc (string->date s "~B~e~Y~H~M")))
  (if (regexp-match "pm" s)
      (add-duration t 12hours)
      t))

(date->string
 (time-utc->date
  (add-duration
   (string->time "March 7 2009 7:30pm est" )
   12hours))
 "~a ~d ~b ~Y ~H:~M")
