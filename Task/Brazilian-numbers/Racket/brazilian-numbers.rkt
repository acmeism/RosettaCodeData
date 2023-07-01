#lang racket

(require math/number-theory)

(define (repeat-digit? n base d-must-be-1?)
  (call-with-values
   (λ () (quotient/remainder n base))
   (λ (q d) (and (or (not d-must-be-1?) (= d 1))
                 (let loop ((n q))
                   (if (zero? n)
                       d
                       (call-with-values
                        (λ () (quotient/remainder n base))
                        (λ (q r) (and (= d r) (loop q))))))))))

(define (brazilian? n (for-prime? #f))
  (for/first ((b (in-range 2 (sub1 n))) #:when (repeat-digit? n b for-prime?)) b))

(define (prime-brazilian? n)
  (and (prime? n) (brazilian? n #t)))

(module+ main
  (displayln "First 20 Brazilian numbers:")
  (stream->list (stream-take (stream-filter brazilian? (in-naturals)) 20))
  (displayln "First 20 odd Brazilian numbers:")
  (stream->list (stream-take (stream-filter brazilian? (stream-filter odd? (in-naturals))) 20))
  (displayln "First 20 prime Brazilian numbers:")
  (stream->list (stream-take (stream-filter prime-brazilian? (stream-filter odd? (in-naturals))) 20)))
