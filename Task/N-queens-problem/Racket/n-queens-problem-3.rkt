#lang racket

(struct Q (x y) #:transparent)

(define-syntax-rule (lcons x y) (cons x (lazy y)))

(define (lazy-filter p? lst)
  (define flst (force lst))
  (if (null? flst) '()
      (let ([x (car flst)])
        (if (p? x)
            (lcons x (lazy-filter p? (cdr flst)))
            (lazy-filter p? (cdr flst))))))

(define (lazy-foldr f base lst)
  (define flst (force lst))
  (if (null? flst) base
      (f (car flst) (lazy (lazy-foldr f base (cdr flst))))))

(define (tails lst)
  (if (null? lst) '(())
      (cons lst (tails (cdr lst)))))

(define (safe? q1 q2)
  (match* (q1 q2)
    [((Q x1 y1) (Q x2 y2))
     (not (or (= x1 x2) (= y1 y2)
              (= (abs (- x1 x2)) (abs (- y1 y2)))))]))

(define (safe-lst? lst)
  (or (null? lst)
      (let ([q1 (car lst)])
        (for/and ([q2 (cdr lst)]) (safe? q1 q2)))))

(define (valid? lst) (andmap safe-lst? (tails lst)))

(define (nqueens n)
  (define all-possible-solutions
    (for/fold ([qss-so-far '(())]) ([row (in-range n)])
      (lazy-foldr
       (λ (qs new-qss)
         (append (for/list ([col (in-range n)]) (cons (Q row col) qs))
                 new-qss))
       '() qss-so-far)))
  (lazy-filter valid? all-possible-solutions))
