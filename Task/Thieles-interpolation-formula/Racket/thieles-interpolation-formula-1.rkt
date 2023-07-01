#lang racket
(define xs (for/vector ([x (in-range 0.0 1.6 0.05)]) x))
(define (x i) (vector-ref xs i))

(define-syntax define-table
  (syntax-rules ()
    [(_ f tf rf if)
     (begin (define tab (for/vector ([x xs]) (f x)))
            (define (tf n) (vector-ref tab n))
            (define cache (make-vector (/ (* 32 31) 2) #f))
            (define (rf n thunk)
              (or (vector-ref cache n)
                  (let ([v (thunk)])
                    (vector-set! cache n v)
                    v)))
            (define (if t) (thiele tf x rf t 0)))]))

(define-table sin tsin rsin isin)
(define-table cos tcos rcos icos)
(define-table tan ttan rtan itan)

(define (rho x y r i n)
  (cond
    [(< n 0) 0]
    [(= n 0) (y i)]
    [else (r (+ (/ (* (- 32 1 n) (- 32 n)) 2) i)
             (λ() (+ (/ (- (x i) (x (+ i n)))
                        (- (rho x y r i (- n 1)) (rho x y r (+ i 1) (- n 1))))
                     (rho x y r (+ i 1) (- n 2)))))]))

(define (thiele x y r xin n)
  (cond
    [(> n 31) 1]
    [(+ (rho x y r 0 n) (- (rho x y r 0 (- n 2)))
        (/ (- xin (x n)) (thiele x y r xin (+ n 1))))]))

(* 6 (isin 0.5))
(* 3 (icos 0.5))
(* 4 (itan 1.))
