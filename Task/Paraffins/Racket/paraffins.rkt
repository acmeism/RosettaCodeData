#lang racket

(define MAX_N 33)
(define BRANCH 4)

(define rooted   (make-vector MAX_N 0))
(define unrooted (make-vector MAX_N 0))
(for ([i 2]) (vector-set! rooted i 1) (vector-set! unrooted i 1))

(define (vector-inc! v i d) (vector-set! v i (+ d (vector-ref v i))))

(define (choose m k)
  (if (= k 1) m
      (for/fold ([r m]) ([i (in-range 1 k)]) (/ (* r (+ m i)) (add1 i)))))

(define (tree br n cnt sum l)
  (let/ec return
    (for ([b (in-range (add1 br) (add1 BRANCH))])
      (define s (+ sum (* (- b br) n)))
      (when (>= s MAX_N) (return))
      (define c (* (choose (vector-ref rooted n) (- b br)) cnt))
      (when (< (* l 2) s) (vector-inc! unrooted s c))
      (when (= b BRANCH) (return))
      (vector-inc! rooted s c)
      (for ([m (in-range (sub1 n) 0 -1)]) (tree b m c s l)))))

(define (bicenter s)
  (when (even? s)
    (vector-inc! unrooted s (* (vector-ref rooted (/ s 2))
                               (add1 (vector-ref rooted (/ s 2)))
                               1/2))))

(for ([n (in-range 1 MAX_N)])
  (tree 0 n 1 1 n)
  (bicenter n)
  (printf "~a: ~a\n" n (vector-ref unrooted n)))
