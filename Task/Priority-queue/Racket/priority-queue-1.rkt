#lang racket
(require data/heap)

(define pq (make-heap (λ(x y) (<= (second x) (second y)))))

(define (insert! x pri)
  (heap-add! pq (list pri x)))

(define (remove-min!)
  (begin0
    (first (heap-min pq))
    (heap-remove-min! pq)))

(insert! 3 "Clear drains")
(insert! 4 "Feed cat")
(insert! 5 "Make tea")
(insert! 1 "Solve RC tasks")
(insert! 2 "Tax return")

(remove-min!)
(remove-min!)
(remove-min!)
(remove-min!)
(remove-min!)
