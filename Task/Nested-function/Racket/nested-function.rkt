#lang racket

(define (make-list separator)
  (define counter 1)

  (define (make-item item)
    (begin0
      (format "~a~a~a~%" counter separator item)
      (set! counter (add1 counter))))

  (apply string-append (map make-item '(first second third))))

(display (make-list ". "))
