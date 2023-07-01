#lang racket/base
(require racket/match)

(define operation-table
  #(#(0 3 1 7 5 9 8 6 4 2)
    #(7 0 9 2 1 5 4 8 6 3)
    #(4 2 0 6 8 7 1 3 5 9)
    #(1 7 5 0 9 8 3 4 2 6)
    #(6 1 2 3 0 4 5 9 7 8)
    #(3 6 7 4 2 0 9 5 8 1)
    #(5 8 6 9 7 2 0 1 3 4)
    #(8 9 4 5 3 6 2 0 1 7)
    #(9 4 3 8 6 1 7 2 0 5)
    #(2 5 8 1 4 3 6 7 9 0)))

(define (integer->digit-list n)
  (let loop ((n n) (a null))
    (if (zero? n) a (let-values (([q r] (quotient/remainder n 10))) (loop q (cons r a))))))

(define/match (check-digit n)
  [((list ds ...))
   (foldl
    (λ (d interim)
      (vector-ref (vector-ref operation-table interim) d))
    0 ds)]
  [((? integer? i))
   (check-digit (integer->digit-list i))])

(define/match (valid-number? n)
  [((? integer? i))
   (valid-number? (integer->digit-list i))]
  [((list ds ...))
   (zero? (check-digit ds))])

(module+ test
  (require rackunit)
  (check-equal? (integer->digit-list 572) '(5 7 2))
  (check-equal? (check-digit 572) 4)
  (check-equal? (check-digit '(5 7 2)) 4)
  (check-true (valid-number? 5724))
  (check-false (valid-number? 5274))
  (check-true (valid-number? 112946)))
