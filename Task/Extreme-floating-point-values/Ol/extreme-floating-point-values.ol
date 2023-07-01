(import (scheme inexact))

(print "infinity: " (/ 1 0))
(print "minus infinity: " (log 0))

; note: (sqrt -1) function will produce 0+i complex number
; so we need to use simpler function "fsqrt"

(import (owl math fp))
(print "not-a-number: " (fsqrt -1))

; note: your must use equal? or eqv? but not eq? for comparison
(print "is this is not a number? " (equal? (fsqrt -1) +nan.0))
