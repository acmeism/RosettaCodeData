#lang racket
(define (real->egyptian-list R)
  (define (inr r rv)
    (match* ((exact-floor r) (numerator r) (denominator r))
      [(0 0 1) (reverse rv)]
      [(0 1 d) (reverse (cons (/ d) rv))]
      [(0 x y) (let ((^y/x (exact-ceiling (/ y x))))
                 (inr (/ (modulo (- y) x) (* y ^y/x)) (cons (/ ^y/x) rv)))]
      [(flr _ _) (inr (- r flr) (cons flr rv))]))
  (inr R null))

(define (real->egyptian-string f)
  (define e.f.-list (real->egyptian-list f))
  (define fmt-part
    (match-lambda
      [(? integer? (app number->string s)) s]
      [(app (compose number->string /) s) (format "/~a"s)]))
  (string-join (map fmt-part e.f.-list) " + "))

(define (stat-egyptian-fractions max-b+1)
  (define-values (max-l max-l-f max-d max-d-f)
    (for*/fold ((max-l 0) (max-l-f #f) (max-d 0) (max-d-f #f))
               ((b (in-range 1 max-b+1)) (a (in-range 1 b)) #:when (= 1 (gcd a b)))
      (define f (/ a b))
      (define e.f (real->egyptian-list (/ a b)))
      (define l (length e.f))
      (define d (denominator (last e.f)))
      (values (max max-l l) (if (> l max-l) f max-l-f)
              (max max-d d) (if (> d max-d) f max-d-f))))
  (printf #<<EOS
max #terms: ~a has ~a
[~.a]
max denominator: ~a has ~a
[~.a]

EOS
          max-l-f max-l (real->egyptian-string max-l-f)
          max-d-f max-d (real->egyptian-string max-d-f)))

(displayln (real->egyptian-string 43/48))
(displayln (real->egyptian-string 5/121))
(displayln (real->egyptian-string 2014/59))
(newline)
(stat-egyptian-fractions 100)
(newline)
(stat-egyptian-fractions 1000)

(module+ test (require tests/eli-tester)
  (test (real->egyptian-list 43/48) => '(1/2 1/3 1/16)))
