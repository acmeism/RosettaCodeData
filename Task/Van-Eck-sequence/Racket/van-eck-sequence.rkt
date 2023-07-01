#lang racket
(require racket/stream)

(define (van-eck)
  (define (next val n seen)
    (define val1 (- n (hash-ref seen val n)))
    (stream-cons val (next val1 (+ n 1) (hash-set seen val n))))
  (next 0 0 (hash)))

(define (get m n s)
  (stream->list
   (stream-take (stream-tail s m)
                (- n m))))

"First 10 terms:"          (get 0     10 (van-eck))
"Terms 991 to 1000 terms:" (get 990 1000 (van-eck)) ; counting from 0
