#lang racket

(define (bind x f) (append-map f x))
(define return list)
(define ((lift f) x) (list (f x)))

(define listy-inc (lift add1))
(define listy-double (lift (λ (x) (* 2 x))))

(bind (bind '(3 4 5) listy-inc) listy-double)
;; => '(8 10 12)

(define (pythagorean-triples n)
  (bind (range 1 n)
        (λ (x)
          (bind (range (add1 x) n)
                (λ (y)
                  (bind (range (add1 y) n)
                        (λ (z)
                          (if (= (+ (* x x) (* y y)) (* z z))
                              (return (list x y z))
                              '()))))))))

(pythagorean-triples 25)
;; => '((3 4 5) (5 12 13) (6 8 10) (8 15 17) (9 12 15) (12 16 20))

(require syntax/parse/define)

(define-syntax-parser do-macro
  [(_ [x {~datum <-} y] . the-rest) #'(bind y (λ (x) (do-macro . the-rest)))]
  [(_ e) #'e])

(define (pythagorean-triples* n)
  (do-macro
   [x <- (range 1 n)]
   [y <- (range (add1 x) n)]
   [z <- (range (add1 y) n)]
   (if (= (+ (* x x) (* y y)) (* z z))
       (return (list x y z))
       '())))

(pythagorean-triples* 25)
;; => '((3 4 5) (5 12 13) (6 8 10) (8 15 17) (9 12 15) (12 16 20))
