(use gauche.array)

(define (print-matrix m)
  (define row-num #f)
  (array-for-each-index m
    (lambda (row col)
      (when (and row-num (not (= row-num row))) (newline))
      (format #t "~a " (array-ref m row col))
      (set! row-num row)))
  (newline))

(define a
  #,(<array> (0 3 0 2)
      a b
      c d
      e f))

(define b
  #,(<array> (0 3 0 2)
      1 2
      3 4
      5 6))

(print-matrix (array-concatenate a b))
(print-matrix (array-concatenate a b 1))
