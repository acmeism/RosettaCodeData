#lang racket
(require srfi/19 math)

(define (days-in-month m y)
  (define lengths #(0 31 #f 31 30 31 30 31 31 30 31 30 31))
  (define d (vector-ref lengths m))
  (or d (days-in-feb y)))

(define (leap-year? y)
  (and (divides? 4 y)
       (or (not (divides? 100 y))
           (divides? 400 y))))

(define (days-in-feb y)
  (if (leap-year? y) 29 28))

(define (last-day-in-month m y)
  (make-date 0 0 0 0 (days-in-month m y) m y 0))

(define (week-day date)
  (define days #(sun mon tue wed thu fri sat))
  (vector-ref days (date-week-day date)))

(define (last-sundays y)
  (for/list ([m (in-range 1 13)])
    (prev-sunday (last-day-in-month m y))))

(define 24hours (make-time time-duration 0 (* 24 60 60)))

(define (prev-day d)
  (time-utc->date
   (subtract-duration
    (date->time-utc d) 24hours)))

(define (prev-sunday d)
  (if (eq? (week-day d) 'sun)
      d
      (prev-sunday (prev-day d))))

(for ([d (last-sundays 2013)])
  (displayln (~a (date->string d "~a ~d ~b ~Y"))))
