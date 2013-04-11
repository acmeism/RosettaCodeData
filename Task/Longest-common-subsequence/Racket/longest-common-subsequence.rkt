#lang racket
(define (longest xs ys)
  (if (> (length xs) (length ys))
      xs ys))

(define memo (make-hash))
(define (lookup xs ys)
  (hash-ref memo (cons xs ys) #f))
(define (store xs ys r)
  (hash-set! memo (cons xs ys) r)
  r)

(define (lcs sx sy)
  (or (lookup sx sy)
      (store sx sy
             (match* (sx sy)
               [((cons x xs) (cons y ys))
                (if (equal? x y)
                    (cons x (lcs xs ys))
                    (longest (lcs sx ys) (lcs xs sy)))]
               [(_ _) '()]))))
