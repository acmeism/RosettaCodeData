#lang racket

(define on-minus
  (case-lambda
    [(ch ip) (on-minus ch ip #f #f #f #f)]
    [(ch ip src line col pos)
     (if (char-numeric? (peek-char ip))
         (- (read ip))
         (datum->syntax #f '-))]))

(define minus-delimits
  (make-readtable (current-readtable) #\- 'terminating-macro on-minus))

(define (range-expand s)
  (parameterize ([current-readtable minus-delimits])
    (append*
     (for/list ([f (in-port read s)])
       (match (peek-char s)
         [#\, (read-char s)
              (list f)]
         [#\- (read-char s)
              (define t (read s))
              (read-char s)
              (range f (+ t 1))])))))

(range-expand (open-input-string "-6,-3--1,3-5,7-11,14,15,17-20"))
