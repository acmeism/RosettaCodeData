#lang racket
(define (natural-sort l)
  (define (list<? l1 l2)
    (cond [(null? l2) #f]
          [(null? l1) #t]
          [(number? (car l1)) (cond [(< (car l1) (car l2)) #t]
                                    [(< (car l2) (car l1)) #f]
                                    [else (list<? (cdr l1) (cdr l2))])]
          [(string? (car l1)) (cond [(string<? (car l1) (car l2)) #t]
                                    [(string<? (car l2) (car l1)) #f]
                                    [else (list<? (cdr l1) (cdr l2))])]))
  (define (->keys s)
    (define s* (string-normalize-spaces (string-foldcase s)))
    (for/list ([x (regexp-match* #px"\\d+" s* #:gap-select? #t)]
               [i (in-naturals)])
      (if (odd? i) (string->number x) x)))
  (sort l list<? #:key ->keys #:cache-keys? #t))

(natural-sort
 (shuffle '("foo9.txt" "foo10.txt" "x9y99" "x9y100" "x10y0" "x  z" "x y")))
;; => '("foo9.txt" "foo10.txt" "x9y99" "x9y100" "x10y0" "x y" "x  z")
