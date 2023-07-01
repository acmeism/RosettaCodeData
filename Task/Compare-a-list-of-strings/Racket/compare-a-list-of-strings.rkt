#lang racket/base
(define ((list-stringX? stringX?) strs)
  (or (null? strs) (null? (cdr strs)) (apply stringX? strs)))
(define list-string=? (list-stringX? string=?))
(define list-string<? (list-stringX? string<?))

(module+ test
  (require tests/eli-tester)
  (test
   (list-string=? '()) => #t
   (list-string=? '("a")) => #t
   (list-string=? '("a" "a")) => #t
   (list-string=? '("a" "a" "a")) => #t
   (list-string=? '("b" "b" "a")) => #f)

  (test
   (list-string<? '()) => #t
   (list-string<? '("a")) => #t
   (list-string<? '("a" "b")) => #t
   (list-string<? '("a" "a")) => #f
   (list-string<? '("a" "b" "a")) => #f
   (list-string<? '("a" "b" "c")) => #t))
