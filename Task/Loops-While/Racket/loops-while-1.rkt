#lang racket
(let loop ([n 1024])
  (when (positive? n)
    (displayln n)
    (loop (quotient n 2))))
