#lang racket

(define (wake-and-split nuts sailors depth wakes)
  (define-values (portion remainder) (quotient/remainder nuts sailors))
  (define monkey (if (zero? depth) 0 1))
  (define new-wakes (cons (list nuts portion remainder) wakes))
  (and (positive? portion)
       (= remainder monkey)
       (if (zero? depth)
           new-wakes
           (wake-and-split (- nuts portion remainder) sailors (sub1 depth) new-wakes))))

(define (sleep-and-split nuts sailors)
  (wake-and-split nuts sailors sailors '()))

(define (monkey_coconuts (sailors 5))
    (let loop ([nuts sailors])
      (or (sleep-and-split nuts sailors)
          (loop (add1 nuts)))))

(for ([sailors (in-range 5 7)])
  (define wakes (monkey_coconuts sailors))
  (printf "For ~a sailors the initial nut count is ~a\n" sailors (first (last wakes)))
  (map displayln (reverse wakes))
  (newline))
