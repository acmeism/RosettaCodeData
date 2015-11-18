;;; Collecting lambdas in a tail-recursive function.
(define (build-list-of-functions n i list)
  (if (< i n)
      (build-list-of-functions n (+ i 1) (cons (lambda () (* (- n i) (- n i))) list))
      list))

(define list-of-functions (build-list-of-functions 10 1 '()))

(map (lambda (f) (f)) list-of-functions)

((list-ref list-of-functions 8))
