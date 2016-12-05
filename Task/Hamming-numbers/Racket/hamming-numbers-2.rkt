#lang racket
(require racket/stream)
(define first stream-first)
(define rest  stream-rest)

(define (hamming)
  (define (merge s1 s2)
    (let ([x1 (first s1)]
          [x2 (first s2)])
      (if (< x1 x2) ; don't have to handle duplicate case
          (stream-cons x1 (merge (rest s1) s2))
          (stream-cons x2 (merge s1 (rest s2))))))
  (define (smult m s) ; faster than using map (* m)
    (define (smlt ss)
      (stream-cons (* m (first ss)) (smlt (rest ss))))
    (smlt s))
  (define (u s n)
    (if (stream-empty? s) ; checking here more efficient than in merge
        (letrec ([r (smult n (stream-cons 1 r))])
          r)
        (letrec ([r (merge s (smult n (stream-cons 1 r)))])
          r)))
  (stream-cons 1 (stream-fold u empty-stream '(5 3 2))))

(for/list ([i 20] [x (hamming)]) x) (newline)
(stream-ref (hamming) 1690) (newline)
(stream-ref (hamming) 999999) (newline)
