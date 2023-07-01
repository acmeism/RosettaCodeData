#lang racket/base
(require racket/match racket/string)

(define (linear-combination->string es)
  (let inr ((es es) (i 1) (rv ""))
    (match* (es rv)
      [((list) "") "0"]
      [((list) rv) rv]
      [((list (? zero?) t ...) rv)
       (inr t (add1 i) rv)]
      [((list n t ...) rv)
       (define ±n
         (match* (n rv)
           ;; zero is handled above
           [(1 "") ""]
           [(1 _) "+"]
           [(-1 _) "-"]
           [((? positive? n) (not "")) (format "+~a*" n)]
           [(n _) (format "~a*" n)]))
       (inr t (add1 i) (string-append rv ±n "e("(number->string i)")"))])))

(for-each
 (compose displayln linear-combination->string)
 '((1 2 3)
   (0 1 2 3)
   (1 0 3 4)
   (1 2 0)
   (0 0 0)
   (0)
   (1 1 1)
   (-1 -1 -1)
   (-1 -2 0 -3)
   (-1)))
