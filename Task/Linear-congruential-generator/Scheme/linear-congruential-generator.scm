(import (scheme base)
        (scheme write))

(define ((bsd-rand state))
  (set! state (remainder (+ (* 1103515245 state) 12345) 2147483648))
    state)

(define ((msvcrt-rand state))
  (set! state (remainder (+ (* 214013 state) 2531011) 2147483648))
    (quotient state 65536))

; auxiliary function to get a list of 'n random numbers from generator 'r
(define (rand-list r n)
  (if (zero? n) '() (cons (r) (rand-list r (- n 1)))))

(display (rand-list (bsd-rand 0) 10))
; (12345 1406932606 654583775 1449466924 229283573 1109335178 1051550459 1293799192 794471793 551188310)

(newline)

(display (rand-list (msvcrt-rand 0) 10))
; (38 7719 21238 2437 8855 11797 8365 32285 10450 30612)
