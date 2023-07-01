#lang racket
(define (ordinal-text d)
  (vector-ref
   (vector
    "zeroth" "first" "second" "third" "fourth"
    "fifth" "sixth" "seventh" "eighth" "ninth"
    "tenth" "eleventh" "twelfth")
   d))

(define (on-the... day)
  (printf "On the ~a day of Christmas,~%" (ordinal-text day))
  (printf "My True Love gave to me,~%"))

(define (prezzy prezzy-line day)
  (match prezzy-line
    [1 (string-append (if (= day 1) "A " "And a")" partridge in a pear tree")]
    [2 "Two turtle doves"]
    [3 "Three French hens"]
    [4 "Four calling birds"]
    [5 "FIVE GO-OLD RINGS"]
    [6 "Six geese a-laying"]
    [7 "Seven swans a-swimming"]
    [8 "Eight maids a-milking"]
    [9 "Nine ladies dancing"]
    [10 "Ten lords a-leaping"]
    [11 "Eleven pipers piping"]
    [12 "Twelve drummers drumming"]))

(define (line-end prezzy-line day)
  (match* (day prezzy-line) [(12 1) "."] [(x 1) ".\n"] [(_ _) ","]))

(for ((day (sequence-map add1 (in-range 12)))
      #:when (on-the... day)
      (prezzy-line (in-range day 0 -1)))
  (printf "~a~a~%" (prezzy prezzy-line day) (line-end prezzy-line day)))
