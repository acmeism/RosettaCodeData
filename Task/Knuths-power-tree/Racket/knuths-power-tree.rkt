#lang racket

(define pow-path-cache (make-hash '((0 . (0)) (1 . (0 1)))))

(define pow-path-level '(1))

(define (pow-path-extend!)
  (define next-level
    (for*/fold ([next-level '()])
               ([x (in-list pow-path-level)]
                [y (in-list (pow-path x))]
                [s (in-value (+ x y))]
                #:when (not (hash-has-key? pow-path-cache s)))
      (hash-set! pow-path-cache s (append (hash-ref pow-path-cache x) (list s)))
      (cons s next-level)))
  (set! pow-path-level (reverse next-level)))

(define (pow-path n)
  (let loop ()
    (unless (hash-has-key? pow-path-cache n)
      (pow-path-extend!)
      (loop)))
 (hash-ref pow-path-cache n))

(define (pow-tree x n)
  (define pows (make-hash `((0 . 1) (1 . ,x))))
  (for/fold ([prev 0])
            ([i (in-list (pow-path n))])
    (hash-set! pows i (* (hash-ref pows (- i prev)) (hash-ref pows prev)))
    i)
  (hash-ref pows n))

(define (show-pow x n)
  (printf "~a: ~a\n" n (cdr (pow-path n)))
  (printf "~a^~a = ~a\n" x n (pow-tree x n)))

(for ([x (in-range 18)])
  (show-pow 2 x))
(show-pow 3 191)
(show-pow 1.1 81)
