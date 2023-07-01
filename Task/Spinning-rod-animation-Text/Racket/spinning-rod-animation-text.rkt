#lang racket
(define (anim)
  (for ([c "\\|/-"])
    (printf "~a\r" c)
    (sleep 0.25))
  (anim))
(anim)
