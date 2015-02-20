#lang racket
(require math (only-in srfi/27 random-real))

(define (histogram n xs Δx)
  (define (r x) (~r x #:precision 1 #:min-width 3))
  (define (len count) (exact-floor (/ (* count 200) n)))
  (for ([b (bin-samples (range 0 1 Δx) <= xs)])
    (displayln (~a (r (sample-bin-min b)) "-" (r (sample-bin-max b)) ": "
                   (make-string (len (length (sample-bin-values b))) #\*)))))

(define (task n)
  (define xs (for/list ([_ n]) (random-real)))
  (displayln (~a "Number of samples: " n))
  (displayln (~a "Mean: " (mean xs)))
  (displayln (~a "Standard deviance: " (stddev xs)))
  (histogram n xs 0.1)
  (newline))

(task 100)
(task 1000)
(task 10000)
