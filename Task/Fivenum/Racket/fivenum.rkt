#lang racket/base
(require math/private/statistics/quickselect)

;; racket's quantile uses "Method 1" of https://en.wikipedia.org/wiki/Quartile
;; Tukey (fivenum) uses "Method 2", so we will need a specialist median
(define (fivenum! data-v)
  (define (tukey-median start end)
    (define-values (n/2 parity) (quotient/remainder (- end start) 2))
    (define mid (+ start n/2))
    (if (zero? parity)
        (/ (+ (data-kth-value! (+ mid (sub1 parity))) (data-kth-value! mid)) 2)
        (data-kth-value! mid)))

  (define n-data (let ((l (vector-length data-v)))
                   (if (zero? l)
                       (raise-argument-error 'data-v "nonempty (Vectorof Real)" data-v)
                       l)))

  (define (data-kth-value! n) (kth-value! data-v n <))

  (define subset-size (let-values (((n/2 parity) (quotient/remainder n-data 2))) (+ n/2 parity)))

  (vector (data-kth-value! 0)
          (tukey-median 0 subset-size)
          (tukey-median 0 n-data)
          (tukey-median (- n-data subset-size) n-data)
          (data-kth-value! (sub1 n-data))))

(define (fivenum data-seq)
  (fivenum! (if (and (vector? data-seq) (not (immutable? data-seq)))
                data-seq
                (for/vector ((datum data-seq)) datum))))

(module+ test
  (require rackunit
           racket/vector)
  (check-equal? #(14 14 14 14 14) (fivenum #(14)) "Minimal case")
  (check-equal? #(8 11 14 17 20) (fivenum #(8 14 20)) "3-value case")
  (check-equal? #(8 11 15 18 20) (fivenum #(8 14 16 20)) "4-value case")

  (define x1-seq #(36 40 7 39 41 15))
  (define x1-v (vector-copy x1-seq))
  (check-equal? x1-seq x1-v "before fivenum! sequence and vector were not `equal?`")
  (check-equal? #(7 15 #e37.5 40 41) (fivenum! x1-v) "Test against Go results x1")
  (check-not-equal? x1-seq x1-v "fivenum! did not mutate mutable input vectors")

  (check-equal? #(6 #e25.5 40 #e42.5 49) (fivenum #(15 6 42 41 7 36 49 40 39 47 43)) "Test against Go results x2")

  (check-equal? #(-1.95059594 -0.676741205 0.23324706 0.746070945 1.73131507)
                (fivenum (vector 0.14082834  0.09748790  1.73131507  0.87636009 -1.95059594  0.73438555
                                 -0.03035726  1.46675970 -0.74621349 -0.72588772  0.63905160  0.61501527
                                 -0.98983780 -1.00447874 -0.62759469  0.66206163  1.04312009 -0.10305385
                                 0.75775634  0.32566578))
                "Test against Go results x3"))
