#lang racket

(require (except-in math/number-theory nth-prime))

(define-syntax-rule (define/cache (name arg) body ...)
  (begin
    (define cache (make-hash))
    (define (name arg)
      (hash-ref! cache arg (lambda () body ...)))))

(define (num-length n)
  ;warning: this defines (num-length 0) as 0
  (if (zero? n)
    0
    (add1 (num-length (quotient n 10)))))

(define/cache (nth-prime n)
  (if (zero? n)
      2
      (for/first ([p (in-naturals (add1 (nth-prime (sub1 n))))]
                  #:when (prime? p))
           p)))

(define (primorial n)
  (if (zero? n)
     1
     (* (primorial (sub1 n))
        (nth-prime (sub1 n)))))

(displayln
 (for/list ([i (in-range 10)])
   (primorial i)))

(for ([i (in-range 1 6)])
  (printf "Primorial(10^~a) has ~a digits.\n"
          i
          (num-length (primorial (expt 10 i)))))
