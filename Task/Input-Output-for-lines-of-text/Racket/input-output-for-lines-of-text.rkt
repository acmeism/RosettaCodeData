#lang racket
(define (do-stuff str)
  (displayln str))

;(define line-count (read)) ;reads all kind of things

(define line-count (string->number ;only reads numbers
                    (string-trim
                     (read-line))))

(for ([i (in-range line-count)])
  (do-stuff (read-line)))
