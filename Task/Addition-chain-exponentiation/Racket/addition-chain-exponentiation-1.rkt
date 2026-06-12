#lang racket
(define (chain n)
  ; computes a simple addition chain for n
  (cond [(= n 1)   '()]
        [(even? n) (define n/2 (/ n 2))
                   (cons (list n n/2 n/2) (chain n/2))]
        [(odd? n)  (define n-1 (- n 1))
                   (cons (list n n-1 1) (chain (- n 1)))]))

(define mult
  (let ([n 0])
    (λ xs
      (cond [(equal? xs (list 'count)) n]
            [(equal? xs (list 'reset)) (set! n 0)]
            [else (set! n (+ n 1))
                  (apply * xs)]))))

(define (expt/chain x n chain)
    ; computes x^n using the addition chain
  (define ht (make-hash))
  (hash-set! ht 1 x)
  (define (expt1 n)
    (or (hash-ref ht n #f)
        (let ()
          (define x^n
            (match (assoc n chain)
              [(list _ s t) (mult (expt1 s) (expt1 t))]))
          (hash-set! ht n x^n)
          x^n)))
  (expt1 n))

(define (test x n)
  (displayln (~a "Chain for " n "\n" (chain n)))
  (mult 'reset)
  (displayln (~a x " ^ " n " = " (expt/chain x n (chain n))))
  (displayln (~a "Multiplications: " (mult 'count)))
  (newline))

(test 1.00002206445416 31415)
(test 1.00002550055251 27182)
