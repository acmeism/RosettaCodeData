#lang racket
(require srfi/19)

(define long-months '(1 3 5 7 8 10 12))
(define days #(sun mon tue wed thu fri sat))

(define (week-day date)
  (vector-ref days (date-week-day date)))

(define (five-weekends-a-month start end)
  (for*/list ([year (in-range start (+ end 1))]
              [month long-months]
              [date (in-value (make-date 0 0 0 0 31 month year 0))]
              #:when (eq? (week-day date) 'sun))
    date))

(define weekends (five-weekends-a-month 1900 2100))
(define count (length weekends))

(displayln (~a "There are " count " weeks with five weekends."))
(displayln "The first five are: ")
(for ([w (take weekends 5)])
  (displayln (date->string w "~b ~Y")))
(displayln "The last five are: ")
(for ([w (drop weekends (- count 5))])
  (displayln (date->string w "~b ~Y")))
