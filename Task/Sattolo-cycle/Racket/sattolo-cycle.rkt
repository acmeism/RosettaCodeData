#lang racket

;; although the shuffle is in-place, returning the shuffled vector makes
;; testing a little easier
(define (sattolo-shuffle v)
  (for ((i (in-range (sub1 (vector-length v)) 0 -1)))
    (define j (random i))
    (define tmp (vector-ref v i))
    (vector-set! v i (vector-ref v j))
    (vector-set! v j tmp))
  v)

(define (derangement-of? A B #:strict? (strict? #t))
  (match* (A B)
    [('() '()) #t]
    [((list a) (list a)) #:when strict? #t]
    [((list a _ ...) (list a _ ...)) #f]
    [((list _ as ...) (list _ bs ...))
     (derangement-of? as bs #:strict? #t)]
    [((vector as ...) (vector bs ...))
     (derangement-of? as bs #:strict? strict?)]))

(module+ test
  (require rackunit)

  (check-equal? (sattolo-shuffle (vector)) #())
  (check-equal? (sattolo-shuffle (vector 10)) #(10))
  (check-equal? (sattolo-shuffle (vector 'inky)) #(inky))

  (define v′ (sattolo-shuffle (vector 11 12 13 14 15 16 17 18 19 20 21)))

  v′

  (check-true (derangement-of? #(11 12 13 14 15 16 17 18 19 20 21) v′)))
