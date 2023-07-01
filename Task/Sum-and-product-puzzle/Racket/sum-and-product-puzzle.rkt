#lang racket
(define-syntax-rule (define/mem (name args ...) body ...)
  (begin
    (define cache (make-hash))
    (define (name args ...)
      (hash-ref! cache (list args ...) (lambda () body ...)))))

(define (sum p) (+ (first p) (second p)))
(define (mul p) (* (first p) (second p)))

(define (sum= p s) (filter (lambda (q) (= p (sum q))) s))
(define (mul= p s) (filter (lambda (q) (= p (mul q))) s))

(define (puzzle tot)
  (printf "Max Sum: ~a\n" tot)
  (define s1 (for*/list ([x (in-range 2 (add1 tot))]
                         [y (in-range (add1 x) (- (add1 tot) x))])
               (list x y)))
  (printf "Possible pairs: ~a\n" (length s1))

  (define/mem (sumEq/all p) (sum= p s1))
  (define/mem (mulEq/all p) (mul= p s1))

  (define s2 (filter (lambda (p) (andmap (lambda (q)
                                           (not (= (length (mulEq/all (mul q))) 1)))
                                         (sumEq/all (sum p))))
                     s1))
  (printf "Initial pairs for S: ~a\n" (length s2))

  (define s3 (filter (lambda (p) (= (length (mul= (mul p) s2)) 1))
                   s2))
  (displayln (length s3))
  (printf "Pairs for P: ~a\n" (length s3))

  (define s4 (filter (lambda (p) (= (length (sum= (sum p) s3)) 1))
                     s3))
  (printf "Final pairs for S: ~a\n" (length s4))

  (displayln s4))

(puzzle 100)
