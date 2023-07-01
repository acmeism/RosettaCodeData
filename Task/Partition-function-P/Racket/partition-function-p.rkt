#lang racket

(require math/number-theory)

(define σ
  (let ((memo (make-hash)))
    (λ (z)
      (hash-ref! memo z
                 (λ () (apply + (divisors z)))))))

(define p
  (let ((memo (make-hash '((0 . 1)))))
    (λ (n)
      (hash-ref!
       memo n
       (λ ()
         (let ((r (if (zero? n) 1
             (/ (for/sum ((k (in-range (sub1 n) -1 -1)))
                  (* (σ (- n k))
                     (p k)))
                n))))
           (when (zero? (modulo n 1000)) (displayln (cons n r) (current-error-port)))
           r))))))

(map p (range 1 30))
(p 666)
(p 1000)
(p 10000)
