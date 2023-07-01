#lang racket

(require racket/hash)

(module+ main (Pentomino-tiling))

(define n-rows 8)
(define n-cols 8)
(define blank '-)

(define (build-grid)
  (for/fold ((grid (for*/hash ((r n-rows) (c n-cols)) (values (cons r c) #f)))) ((_ 4))
    (hash-set grid (cons (random n-rows) (random n-cols)) blank)))

(define (make-shapes-map)
  (hash 'F (F) 'I (I) 'L (L) 'N (N) 'P (P) 'T (T) 'U (U) 'V (V) 'W (W) 'X (X) 'Y (Y) 'Z (Z)))

(define (print-grid grid)
  (for ((r n-rows) #:when (when (positive? r) (newline)) (c n-cols))
    (write (hash-ref grid (cons r c))))
  (newline))

(define (Pentomino-tiling (grid (build-grid)))
  (define solution (solve 0 grid (make-shapes-map)))
  (if solution (print-grid solution) (displayln "no solution")))

(define (solve p grid shapes (failed-shapes (hash)))
  (define-values (r c) (quotient/remainder p n-cols))
  (cond [(not grid) #f]
        [(hash-empty? shapes) (and (hash-empty? failed-shapes) grid)]
        [(hash-ref grid (cons r c) #f) (solve (add1 p) grid shapes failed-shapes)]
        [else
         (define s (car (hash-keys shapes)))
         (define os (hash-ref shapes s))
         (define shapes-s (hash-remove shapes s))
         (define (try-place-orientation o)
           (and (for/and ((dy.dx o))
                  (let ((y (+ r (car dy.dx))) (x (+ c (cdr dy.dx))))
                    (and (>= x 0) (>= y 0) (< x n-cols) (< y n-rows) (not (hash-ref grid (cons y x))))))
                (for/fold ((grid (hash-set grid (cons r c) s))) ((dy.dx o))
                  (hash-set grid (cons (+ r (car dy.dx)) (+ c (cdr dy.dx))) s))))
         (or (for*/first
                 ((o os)
                  (solution (in-value (solve (add1 p)
                                             (try-place-orientation o)
                                             (hash-union shapes-s failed-shapes))))
                  #:when solution)
               solution)
             (solve p grid shapes-s (hash-set failed-shapes s os)))]))

(define (F) '(((1 . -1) (1 . 0) (1 . 1) (2 . 1))
              ((0 . 1) (1 . -1) (1 . 0) (2 . 0))
              ((1 . 0) (1 . 1) (1 . 2) (2 . 1))
              ((1 . 0) (1 . 1) (2 . -1) (2 . 0))
              ((1 . -2) (1 . -1) (1 . 0) (2 . -1))
              ((0 . 1) (1 . 1) (1 . 2) (2 . 1))
              ((1 . -1) (1 . 0) (1 . 1) (2 . -1))
              ((1 . -1) (1 . 0) (2 . 0) (2 . 1))))

(define (I) '(((0 . 1) (0 . 2) (0 . 3) (0 . 4))
              ((1 . 0) (2 . 0) (3 . 0) (4 . 0))))

(define (L) '(((1 . 0) (1 . 1) (1 . 2) (1 . 3))
              ((1 . 0) (2 . 0) (3 . -1) (3 . 0))
              ((0 . 1) (0 . 2) (0 . 3) (1 . 3))
              ((0 . 1) (1 . 0) (2 . 0) (3 . 0))
              ((0 . 1) (1 . 1) (2 . 1) (3 . 1))
              ((0 . 1) (0 . 2) (0 . 3) (1 . 0))
              ((1 . 0) (2 . 0) (3 . 0) (3 . 1))
              ((1 . -3) (1 . -2) (1 . -1) (1 . 0))))

(define (N) '(((0 . 1) (1 . -2) (1 . -1) (1 . 0))
              ((1 . 0) (1 . 1) (2 . 1) (3 . 1))
              ((0 . 1) (0 . 2) (1 . -1) (1 . 0))
              ((1 . 0) (2 . 0) (2 . 1) (3 . 1))
              ((0 . 1) (1 . 1) (1 . 2) (1 . 3))
              ((1 . 0) (2 . -1) (2 . 0) (3 . -1))
              ((0 . 1) (0 . 2) (1 . 2) (1 . 3))
              ((1 . -1) (1 . 0) (2 . -1) (3 . -1))))

(define (P) '(((0 . 1) (1 . 0) (1 . 1) (2 . 1))
              ((0 . 1) (0 . 2) (1 . 0) (1 . 1))
              ((1 . 0) (1 . 1) (2 . 0) (2 . 1))
              ((0 . 1) (1 . -1) (1 . 0) (1 . 1))
              ((0 . 1) (1 . 0) (1 . 1) (1 . 2))
              ((1 . -1) (1 . 0) (2 . -1) (2 . 0))
              ((0 . 1) (0 . 2) (1 . 1) (1 . 2))
              ((0 . 1) (1 . 0) (1 . 1) (2 . 0))))

(define (T) '(((0 . 1) (0 . 2) (1 . 1) (2 . 1))
              ((1 . -2) (1 . -1) (1 . 0) (2 . 0))
              ((1 . 0) (2 . -1) (2 . 0) (2 . 1))
              ((1 . 0) (1 . 1) (1 . 2) (2 . 0))))

(define (U) '(((0 . 1) (0 . 2) (1 . 0) (1 . 2))
              ((0 . 1) (1 . 1) (2 . 0) (2 . 1))
              ((0 . 2) (1 . 0) (1 . 1) (1 . 2))
              ((0 . 1) (1 . 0) (2 . 0) (2 . 1))))

(define (V) '(((1 . 0) (2 . 0) (2 . 1) (2 . 2))
              ((0 . 1) (0 . 2) (1 . 0) (2 . 0))
              ((1 . 0) (2 . -2) (2 . -1) (2 . 0))
              ((0 . 1) (0 . 2) (1 . 2) (2 . 2))))

(define (W) '(((1 . 0) (1 . 1) (2 . 1) (2 . 2))
              ((1 . -1) (1 . 0) (2 . -2) (2 . -1))
              ((0 . 1) (1 . 1) (1 . 2) (2 . 2))
              ((0 . 1) (1 . -1) (1 . 0) (2 . -1))))

(define (X) '(((1 . -1) (1 . 0) (1 . 1) (2 . 0))))

(define (Y) '(((1 . -2) (1 . -1) (1 . 0) (1 . 1))
              ((1 . -1) (1 . 0) (2 . 0) (3 . 0))
              ((0 . 1) (0 . 2) (0 . 3) (1 . 1))
              ((1 . 0) (2 . 0) (2 . 1) (3 . 0))
              ((0 . 1) (0 . 2) (0 . 3) (1 . 2))
              ((1 . 0) (1 . 1) (2 . 0) (3 . 0))
              ((1 . -1) (1 . 0) (1 . 1) (1 . 2))
              ((1 . 0) (2 . -1) (2 . 0) (3 . 0))))

(define (Z) '(((0 . 1) (1 . 0) (2 . -1) (2 . 0))
              ((1 . 0) (1 . 1) (1 . 2) (2 . 2))
              ((0 . 1) (1 . 1) (2 . 1) (2 . 2))
              ((1 . -2) (1 . -1) (1 . 0) (2 . -2))))
