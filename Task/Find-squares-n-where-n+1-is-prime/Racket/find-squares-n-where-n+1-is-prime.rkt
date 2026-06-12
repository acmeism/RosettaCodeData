#lang racket

(define (find-subprime-squares up-to)
  (let rc ([curr-num 1]
           [found '()])
    (let ([n-sq (* curr-num curr-num)])
      (cond [(>= n-sq up-to) (reverse found)]
            [(prime? (add1 n-sq)) (rc (add1 curr-num) (cons n-sq found))]
            [else (rc (add1 curr-num) found)]))))

(define (prime? n)
  (let iter ([counter 2])
    (cond [(eq? n 1) #f]
          [(<= (expt counter 2) n)
           (if (zero? (remainder n counter))
               #f
               (iter (add1 counter)))]
          [else #t])))

(find-subprime-squares 1000)
