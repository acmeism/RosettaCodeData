#lang racket
(define (remove x lst)
  (for/list ([i (in-range (length lst))]
             #:when (not (= x i)))
    (list-ref lst i)))

(define (switch-pairs lst)
  (cond [(null? lst) '()]
        [(null? (cdr lst)) (list '() (car lst))]
        [else (append (list (cadr lst) (car lst))
                      (switch-pairs (cddr lst)))]))

(define (switch-places a1 a2 lst)
  (for/list ([i (length lst)])
    (list-ref lst (cond [(= a1 i) a2] [(= a2 i) a1] [else i]))))

(define (position-queens n)
  (cond [(= 1 n) (list (list 1))]
        [(> 4 n) #f]
        [else (possible-queens n)]))

(define (possible-queens n)
  (define rem (remainder n 12))
  (define lst (build-list n add1))
  (define evens (filter even? lst))
  (define odds (filter odd? lst))
  (cond [(or (= rem 9) (= rem 3)) (case3or9 evens odds)]
        [(= rem 8) (case8 evens odds)]
        [(= rem 2) (case2 evens odds)]
        [else (append evens odds)]))

(define (case3or9 evens odds)
  (for/fold ([acum (append (cdr evens) (list (car evens)) odds)])
            ([i (in-list '(1 3))])
    (append (remove (list-ref acum i) acum) (list i))))

(define (case8 evens odds)
  (append evens (switch-pairs odds)))

(define (case2 evens odds)
  (define nums (append evens odds))
  (define idx (map (λ(i) (list-ref nums i)) '(1 3 5)))
  (append (remove (caddr idx)
                  (switch-places (car idx) (cadr idx) nums))
          '(5)))

(define (queens n)
  (define position-numbers (position-queens n))
  (define positions-on-board
    (for/list ([i n]) (cons i (sub1 (list-ref position-numbers i)))))
  (for/list ([x n])
    (for/list ([y n])
      (if (member (cons x y) positions-on-board) "Q" "."))))

(define (print-queens n)
  (for ([x (queens n)]) (displayln (string-join x))))
