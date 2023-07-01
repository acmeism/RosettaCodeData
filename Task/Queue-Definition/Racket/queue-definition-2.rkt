#lang racket
;; Invariants:
;; The elements in the queue are (append front (reverse back)).
;; Front is always non-empty (except for the empty queue).
(struct queue (front back))

(define empty (queue '() '()))

(define (push x q)
  (if (null? (queue-front q))
      (queue (reverse (cons x (queue-back q))) '())
      (queue (queue-front q) (cons x (queue-back q)))))

(define (empty? q)
  (null? (queue-front q)))

(define (pop q)
  (cond [(empty? q) (error 'pop "the queue is empty")]
        [(not (null? (queue-front q)))
         (if (null? (rest (queue-front q)))
             (queue (reverse (queue-back q)) '())
             (queue (rest (queue-front q)) (queue-back q)))]
        [else (queue (reverse (queue-back q)) '())]))

(define (first q)
  (cond [(empty? q) (error 'first "the queue is empty")]
        [(car (queue-front q))]))

;; Example:
(first (pop (pop (for/fold ([q empty]) ([x '(1 2 3 4)])
                   (push x q)))))
;; => 3
