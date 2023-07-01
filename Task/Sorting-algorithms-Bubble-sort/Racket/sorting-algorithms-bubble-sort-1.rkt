#lang racket

(define (bubble-sort <? v)
  (define len (vector-length v))
  (define ref vector-ref)
  (let loop ([max len]
             [again? #f])
    (for ([i (in-range 0 (- max 1))]
          [j (in-range 1 max)])
      (define vi (ref v i))
      (when (<? (ref v j) vi)
        (vector-set! v i (ref v j))
        (vector-set! v j vi)
        (set! again? #t)))
    (when again? (loop (- max 1) #f)))
  v)
