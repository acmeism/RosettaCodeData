#lang racket/base

(define (s-of-n-creator n)
  (define i 0)
  (define sample (make-vector n)) ; the sample of n items
  (lambda (item)
    (set! i (add1 i))
    (cond [(<= i n)               ; we're not full, so kind of boring
           (vector-set! sample (sub1 i) item)]
          [(< (random i) n)       ; we've already seen n items; swap one?
           (vector-set! sample (random n) item)])
    sample))

(define counts (make-vector 10 0))

(for ([i 100000])
  (define s-of-n (s-of-n-creator 3))
  (define sample (for/last ([digit 10]) (s-of-n digit)))
  (for ([d sample]) (vector-set! counts d (add1 (vector-ref counts d)))))

(for ([d 10]) (printf "~a ~a\n" d (vector-ref counts d)))
