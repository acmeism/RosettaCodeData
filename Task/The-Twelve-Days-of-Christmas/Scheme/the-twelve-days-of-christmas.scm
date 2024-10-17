; Racket has this built in, but it's not standard
(define (take lst n)
  (if (or (null? lst) (<= n 0))
      '()
      (cons (car lst) (take (cdr lst) (- n 1)))))

(let
  ((days  '("first" "second" "third" "fourth" "fifth" "sixth" "seventh"
            "eighth" "ninth" "tenth" "eleventh" "twelfth"))

   (gifts '("A partridge in a pear tree." "Two turtle doves, and"
            "Three French hens,"          "Four calling birds,"
            "Five gold rings,"            "Six geese a-laying,"
            "Seven swans a-swimming,"     "Eight maids a-milking,"
            "Nine ladies dancing,"        "Ten lords a-leaping,"
            "Eleven pipers piping,"       "Twelve drummers drumming,")))

  (do ((left days (cdr left))
       ; No universal predefined (+ 1) function, sadly. Implementations
       ; are divided between (add1) and (1+).
       (day  1    (+ 1 day)))
      ((null? left) #t)

    (display "On the ")
    (display (car left))
    (display " day of Christmas, my true love sent to me:")
    (newline)

    (do ((daily (reverse (take gifts day)) (cdr daily)))
        ((null? daily) #t)

      (display (car daily))
      (newline))
      (newline)))

(exit)
