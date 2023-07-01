#lang racket

(require syntax/parse/define)

(define (bind x f) (and x (f x)))
(define return identity)

;; error when arg = 0
(define reciprocal (curry / 1))
;; error when arg < 0
(define (root x) (if (< x 0) (error 'bad) (sqrt x)))
;; error whe  arg <= 0
(define (ln x) (if (<= x 0) (error 'bad) (log x)))

(define (lift f check) (λ (x) (and (check x) (f x))))

(define safe-reciprocal (lift reciprocal (negate (curry equal? 0))))
(define safe-root (lift root (curry <= 0)))
(define safe-ln (lift ln (curry < 0)))

(define (safe-log-root-reciprocal x)
  (bind (bind (bind x safe-reciprocal) safe-root) safe-ln))

(define tests `(-2 -1 -0.5 0 1 ,(exp -1) 1 2 ,(exp 1) 3 4 5))

(map safe-log-root-reciprocal tests)

(define-syntax-parser do-macro
  [(_ [x {~datum <-} y] . the-rest) #'(bind y (λ (x) (do-macro . the-rest)))]
  [(_ e) #'e])

(define (safe-log-root-reciprocal* x)
  (do-macro [x <- (safe-reciprocal x)]
            [x <- (safe-root x)]
            [x <- (safe-ln x)]
            (return x)))

(map safe-log-root-reciprocal* tests)
