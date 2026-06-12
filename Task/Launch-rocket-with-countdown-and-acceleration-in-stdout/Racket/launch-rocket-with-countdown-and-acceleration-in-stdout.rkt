#lang racket

(define rocket #<<EOF
   /\
  (  )
  (  )
 /|/\|\
/_||||_\
EOF
  )

(define (cls) (displayln "\x1B[2J"))

(define (print-rocket n)
  (displayln rocket)
  (for ([i (in-range n)]) (displayln "")))

(for ([i (in-range 5 0 -1)])
  (cls)
  (printf "~a =>\n" i)
  (print-rocket 0)
  (sleep 1))

(cls)
(printf "Liftoff!\n")
(print-rocket 1)
(sleep 1)

(for/fold ([ms 1000] #:result (void)) ([n (in-range 2 100)])
  (cls)
  (print-rocket n)
  (sleep (/ ms 1000))
  (if (>= ms 40) (- ms 40) 0))
