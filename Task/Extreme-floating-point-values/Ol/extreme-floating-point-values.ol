(print "infinity: " (/ 1 (inexact 0))
(print "minus infinity: " (/ -1 (inexact 0))
(print "not-a-number: " (/ 0 (inexact 0))

; note: your must use equal? or eqv? but not eq? for comparison
(print "is this is not a number? " (equal? (/ 0 (inexact 0)) +nan.0))
