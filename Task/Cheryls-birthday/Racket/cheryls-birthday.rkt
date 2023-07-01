#lang racket

(define ((is x #:key [key identity]) y) (equal? (key x) (key y)))

(define albert first)
(define bernard second)

(define (((unique who) chs) date) (= 1 (count (is date #:key who) chs)))

(define (((unique-fix who-fix who) chs) date)
  (ormap (conjoin (is date #:key who-fix) ((unique who) chs)) chs))

(define-syntax-rule (solve <chs> [<act> <arg>] ...)
  (let* ([chs <chs>] [chs (<act> (<arg> chs) chs)] ...) chs))

(solve '((May 15) (May 16) (May 19) (June 17) (June 18)
         (July 14) (July 16) (August 14) (August 15) (August 17))

       ;; Albert knows the month but doesn't know the day.
       ;; So the month can't be unique within the choices.
       [filter-not (unique albert)]
       ;; Albert also knows that Bernard doesn't know the answer.
       ;; So the month can't have a unique day.
       [filter-not (unique-fix albert bernard)]
       ;; Bernard now knows the answer.
       ;; So the day must be unique within the remaining choices.
       [filter (unique bernard)]
       ;; Albert now knows the answer too.
       ;; So the month must be unique within the remaining choices
       [filter (unique albert)])
