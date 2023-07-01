#lang racket/base
(require racket/string
         racket/list)

(define (seconds->compound-durations s)
  (define-values (w d.h.m.s)
    (for/fold ((prev-q s) (rs (list))) ((Q (in-list (list 60 60 24 7))))
      (define-values (q r) (quotient/remainder prev-q Q))
      (values q (cons r rs))))
  (cons w d.h.m.s))

(define (maybe-suffix v n)
  (and (positive? v)
       (format "~a ~a" v n)))

(define (seconds->compound-duration-string s)
  (string-join (filter-map maybe-suffix
                           (seconds->compound-durations s)
                           '("wk" "d" "hr" "min" "sec"))
               ", "))

(module+ test
  (require rackunit)
  (check-equal? (seconds->compound-durations 7259)    (list 0 0  2  0 59))
  (check-equal? (seconds->compound-durations 86400)   (list 0 1  0  0  0))
  (check-equal? (seconds->compound-durations 6000000) (list 9 6 10 40  0))

  (check-equal? (seconds->compound-duration-string 7259)    "2 hr, 59 sec")
  (check-equal? (seconds->compound-duration-string 86400)   "1 d")
  (check-equal? (seconds->compound-duration-string 6000000) "9 wk, 6 d, 10 hr, 40 min"))

;; Tim Brown 2015-07-21
