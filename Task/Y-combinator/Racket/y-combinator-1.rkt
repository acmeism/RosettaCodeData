#lang lazy

(define Y (λ(f)((λ(x)(f (x x)))(λ(x)(f (x x))))))

(define Fact
  (Y (λ(fact) (λ(n) (if (zero? n) 1 (* n (fact (- n 1))))))))
(define Fib
  (Y (λ(fib) (λ(n) (if (<= n 1) n (+ (fib (- n 1)) (fib (- n 2))))))))
