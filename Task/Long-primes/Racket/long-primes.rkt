#lang racket
(require math/number-theory)

(define (find-period n)
  (let ((rr (for/fold ((r 1))
                      ((i (in-range 1 (+ n 2))))
              (modulo (* 10 r) n))))
    (let period-loop ((r rr) (p 1))
      (let ((r′ (modulo (* 10 r) n)))
        (if (= r′ rr) p (period-loop r′ (add1 p)))))))

(define (long-prime? n)
  (and (prime? n) (= (find-period n) (sub1 n))))

(define memoised-long-prime? (let ((h# (make-hash))) (λ (n) (hash-ref! h# n (λ () (long-prime? n))))))

(module+ main
  ;; strictly, won't test 500 itself... but does it look prime to you?
  (filter memoised-long-prime? (range 7 500 2))
  (for-each
   (λ (n) (displayln (cons n (for/sum ((i (in-range 7 n 2))) (if (memoised-long-prime? i) 1 0)))))
   '(500 1000 2000 4000 8000 16000 32000 64000)))

(module+ test
  (require rackunit)
  (check-equal? (map find-period '(7 11 977)) '(6 2 976)))
