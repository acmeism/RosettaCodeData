#lang racket
(define (guess minimum maximum)
  (printf "Think of a number from ~a to ~a, use (h)igh, (l)ow and (c)orrect." minimum maximum)

  (define input "")

  (do ((guess (round (/ (+ maximum minimum) 2))  (round (/ (+ maximum minimum) 2))))
    ((string=? input "c"))
    (printf "My guess is: ~a\n(h/l/=) > ")
    (when (string=? input "h")
      (begin (display "OK...")
               (set! maximum (sub1 guess))))
        (when (string=? input "l")
          (begin (display "OK...")
                 (set! minimum (add1 guess)))))
  (displayln "I was RIGHT!"))
