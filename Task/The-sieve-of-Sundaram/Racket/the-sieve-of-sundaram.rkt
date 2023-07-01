#lang racket

(define (make-sieve-as-set limit)
  (let ((marked (for/mutable-set ((i limit)) (add1 i))))
    (let loop ((start 4) (step 3))
      (cond [(>= start limit) marked]
            [else (for ((i (in-range start limit step))) (set-remove! marked i))
                  (loop (+ start 3) (+ step 2))]))
    (define (prime? n)
      (and (odd? n)
           (let ((idx (quotient (sub1 n) 2)))
             (unless (<= idx limit) (error 'out-of-bounds))
             (set-member? marked idx))))
    (values marked prime?)))

(define (Sieve-of-Sundaram)
  (define-values (sieve#1 prime?#1) (make-sieve-as-set 1000))
  (displayln (for/list ((i 100) (p (sequence-filter prime?#1 (in-naturals)))) p))

  ;; this will generate primes *twice* as big, which should include 15485867...
  (define-values (sieve#2 prime?#2) (make-sieve-as-set 10000000))
  (define sorted-sieve#2 (sort (set->list sieve#2) <))
  (displayln (add1 (* 2 (list-ref sorted-sieve#2 (sub1 1000000))))))

(module+ main
  (Sieve-of-Sundaram))
