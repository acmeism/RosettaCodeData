#lang racket
(require data/order)

;; allows for key caching
(define (oid->oid-key o)
  (map string->number (string-split o ".")))

(define oid-key< (order-<? datum-order))

(module+ test
  (require rackunit)
  (check-equal?
   (sort
    '("1.3.6.1.4.1.11.2.17.19.3.4.0.10"
      "1.3.6.1.4.1.11.2.17.5.2.0.79"
      "1.3.6.1.4.1.11.2.17.19.3.4.0.4"
      "1.3.6.1.4.1.11150.3.4.0.1"
      "1.3.6.1.4.1.11.2.17.19.3.4.0.1"
      "1.3.6.1.4.1.11150.3.4.0")
    oid-key<
    #:key oid->oid-key
    #:cache-keys? #t)
   '("1.3.6.1.4.1.11.2.17.5.2.0.79"
     "1.3.6.1.4.1.11.2.17.19.3.4.0.1"
     "1.3.6.1.4.1.11.2.17.19.3.4.0.4"
     "1.3.6.1.4.1.11.2.17.19.3.4.0.10"
     "1.3.6.1.4.1.11150.3.4.0"
     "1.3.6.1.4.1.11150.3.4.0.1")))
