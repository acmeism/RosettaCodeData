#lang racket

(define (make-queue) (mcons #f #f))
(define (push! q x)
  (define new (mcons x #f))
  (if (mcar q) (set-mcdr! (mcdr q) new) (set-mcar! q new))
  (set-mcdr! q new))
(define (pop! q)
  (define old (mcar q))
  (cond [(eq? old (mcdr q)) (set-mcar! q #f) (set-mcdr! q #f)]
        [else (set-mcar! q (mcdr old))])
  (mcar old))
(define (empty? q)
  (not (mcar q)))

(define Q (make-queue))
(empty? Q) ; -> #t
(push! Q 'x)
(empty? Q) ; -> #f
(for ([x 3]) (push! Q x))
(pop! Q)   ; -> 'x
(list (pop! Q) (pop! Q) (pop! Q)) ; -> '(0 1 2)
