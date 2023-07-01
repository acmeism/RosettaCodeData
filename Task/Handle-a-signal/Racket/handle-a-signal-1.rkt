#lang racket
(define now current-milliseconds)
(define start (now))
(with-handlers ([exn:break?
                 (λ(x)
                   (define elapsed (/ (- (now) start) 1000.))
                   (displayln (~a "Total time: " elapsed)))])
  (for ([i (in-naturals)])
    (displayln i)
    (sleep 0.5)))
