#lang racket
(require gmp)

(define (factorial-boundary-stream)
  (define (factorial-stream-iter n curr-fact)
    (stream-cons `(- ,n ,(sub1 curr-fact))
                 (stream-cons `(+ ,n ,(add1 curr-fact))
                              (factorial-stream-iter (add1 n) (* curr-fact (+ n 1))))))
  (factorial-stream-iter 1 1))

(define (format-large-number n)
  (let* ([num-chars (number->string n)]
         [num-len (string-length num-chars)])
    (if (> num-len 40)
        (string-append
         (substring num-chars 0 19)
         "..."
         (substring num-chars (- num-len 19) num-len)
         (format " (total ~a digits)" num-len))
        n)))

(define (factorial-printer triple)
  (let-values ([(op n fact) (apply values triple)])
    (let ([fact (format-large-number fact)])
      (displayln (format "~a! ~a 1 = ~a" n op fact)))))

(define (prime? n)
  (not (zero? (mpz_probab_prime_p (mpz n) 10))))

(for ([i (in-stream
          (stream-take
           (stream-filter (λ (l) (prime? (third l))) (factorial-boundary-stream)) 30))]
      [n (in-naturals 1)])
  (begin
    (display (format "~a:\t" n))
    (factorial-printer i)))

;; time output of above code: 2.46 seconds
