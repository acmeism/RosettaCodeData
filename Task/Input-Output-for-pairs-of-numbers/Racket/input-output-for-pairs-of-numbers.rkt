#lang racket
;(define line-number (read)) ;reads all kind of things
;(for ([i (in-range line-number)])
;  (displayln (+ (read) (read))))

(define line-count (string->number ;only reads numbers
                    (string-trim (read-line))))

(for ([i (in-range line-count)])
  (displayln (apply +
                    (map string->number
                         (string-split (read-line))))))
