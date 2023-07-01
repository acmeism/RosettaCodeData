#lang racket

(define (subleq v)
  (define (mem n)
    (vector-ref v n))
  (define (mem-set! n x)
    (vector-set! v n x))
  (let loop ([ip 0])
    (when (>= ip 0)
      (define m0 (mem ip))
      (define m1 (mem (add1 ip)))
      (cond
        [(< m0 0) (mem-set! m1 (read-byte))
                  (loop (+ ip 3))]
        [(< m1 0) (write-byte (mem m0))
                  (loop (+ ip 3))]
        [else (define v (- (mem m1) (mem m0)))
              (mem-set! m1 v)
              (if (<= v 0)
                 (loop (mem (+ ip 2)))
                 (loop (+ ip 3)))]))))

(define Hello (vector 15 17 -1 17 -1 -1 16 1 -1 16 3 -1 15 15 0 0 -1
                    ; H    e    l    l    o    ,  <sp> w    o    r    l    d    !   \n
                      72   101  108  108  111  44  32  119  111  114  108  100  33  10
                      0))

(subleq Hello)
