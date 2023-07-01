;; Text from a semicolon to the end of a line is ignored
;; This lets the racket engine know it is running racket
#lang racket

;; “define” defines a function in the engine
;; we can use an English name for the function
;; a number ends in 269696 when its remainder when
;; divided by 1000000 is 269696 (we omit commas in
;; numbers... they are used for another reason).
(define (ends-in-269696? x)
  (= (remainder x 1000000) 269696))

;; we now define another function square-ends-in-269696?
;; actually this is the composition of ends-in-269696? and
;; the squaring function (which is called “sqr” in racket)
(define square-ends-in-269696? (compose ends-in-269696? sqr))

;; a for loop lets us iterate (it’s a long Latin word which
;; Victorians are good at using) over a number range.
;;
;; for/first go through the range and break when it gets to
;; the first true value
;;
;; (in-range a b) produces all of the integers from a (inclusive)
;; to b (exclusive). Because we know that 99736² ends in 269696,
;; we will stop there. The add1 is to make in-range include 99736
;;
;; we define a new variable, so that we can test the verity of
;; our result
(define first-number-that-when-squared-ends-in-269696
(for/first ((i ; “i” will become the ubiquetous looping variable of the future!
             (in-range 1 (add1 99736)))
            ; when returns when only the first one that matches
            #:when (square-ends-in-269696? i))
  i))

;; display prints values out; newline writes a new line (otherwise everything
;; gets stuck together)
(display first-number-that-when-squared-ends-in-269696)
(newline)
(display (sqr first-number-that-when-squared-ends-in-269696))
(newline)
(newline)
(display (ends-in-269696? (sqr first-number-that-when-squared-ends-in-269696)))
(newline)
(display (square-ends-in-269696? first-number-that-when-squared-ends-in-269696))
(newline)
;; that all seems satisfactory
