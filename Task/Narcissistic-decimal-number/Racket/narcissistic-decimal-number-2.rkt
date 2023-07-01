#lang racket
(define (non-decrementing-digital-sequences L)
  (define (inr d l)
    (cond
      [(<= l 0) '(())]
      [(= d 9) (list (make-list l d))]
      [else (append (map (curry cons d) (inr d (- l 1))) (inr (+ d 1) l))]))
  (inr 0 L))

(define (integer->digits-list n)
  (let inr ((n n) (l null)) (if (zero? n) l (inr (quotient n 10) (cons (modulo n 10) l)))))

(define (narcissitic-numbers-of-length L)
  (define tail-digits (non-decrementing-digital-sequences (sub1 L)))
  (define powers-v (for/fxvector #:length 10 ((i 10)) (expt i L)))
  (define (powers-sum dgts) (for/sum ((d (in-list dgts))) (fxvector-ref powers-v d)))
  (for*/list
      ((dgt1 (in-range 1 10))
       (dgt... (in-list tail-digits))
       (sum-dgt^l (in-value (powers-sum (cons dgt1 dgt...))))
       (dgts-sum (in-value (integer->digits-list sum-dgt^l)))
       #:when (= (car dgts-sum) dgt1)
       ; only now is it worth sorting the digits
       #:when (equal? (sort (cdr dgts-sum) <) dgt...))
    sum-dgt^l))

(define (narcissitic-numbers-of-length<= L)
  (cons 0 ; special!
        (apply append (for/list ((l (in-range 1 (+ L 1)))) (narcissitic-numbers-of-length l)))))

(module+ main
  (define all-narcissitics<10000000
    (narcissitic-numbers-of-length<= 7))
  ; conveniently, this *is* the list of 25... but I'll be a bit pedantic anyway
  (take all-narcissitics<10000000 25))

(module+ test
  (require rackunit)
  (check-equal? (non-decrementing-digital-sequences 1) '((0) (1) (2) (3) (4) (5) (6) (7) (8) (9)))
  (check-equal?
   (non-decrementing-digital-sequences 2)
   '((0 0) (0 1) (0 2) (0 3) (0 4) (0 5) (0 6) (0 7) (0 8) (0 9)
           (1 1) (1 2) (1 3) (1 4) (1 5) (1 6) (1 7) (1 8) (1 9)
           (2 2) (2 3) (2 4) (2 5) (2 6) (2 7) (2 8) (2 9)
           (3 3) (3 4) (3 5) (3 6) (3 7) (3 8) (3 9)
           (4 4) (4 5) (4 6) (4 7) (4 8) (4 9)
           (5 5) (5 6) (5 7) (5 8) (5 9) (6 6) (6 7) (6 8) (6 9)
           (7 7) (7 8) (7 9) (8 8) (8 9) (9 9)))

  (check-equal? (integer->digits-list 0) null)
  (check-equal? (integer->digits-list 7) '(7))
  (check-equal? (integer->digits-list 10) '(1 0))

  (check-equal? (narcissitic-numbers-of-length 1) '(1 2 3 4 5 6 7 8 9))
  (check-equal? (narcissitic-numbers-of-length 2) '())
  (check-equal? (narcissitic-numbers-of-length 3) '(153 370 371 407))

  (check-equal? (narcissitic-numbers-of-length<= 1) '(0 1 2 3 4 5 6 7 8 9))
  (check-equal? (narcissitic-numbers-of-length<= 3) '(0 1 2 3 4 5 6 7 8 9 153 370 371 407)))
