; initial state = closed = #f
(define doors (make-vector 101 #f))
; run pass 100 to 1
(for*
   ((pass (in-range 100 0 -1))
   (door (in-range 0 101 pass)))
    (when (and
        (vector-set! doors door (not (vector-ref doors door)))
        (= pass 1))
        (writeln door "is open")))

1     "is open"
4     "is open"
9     "is open"
16     "is open"
25     "is open"
36     "is open"
49     "is open"
64     "is open"
81     "is open"
100     "is open"
