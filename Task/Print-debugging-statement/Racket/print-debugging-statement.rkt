#lang racket

(require syntax/parse/define)

(define (debug:core line col code val #:label [label #f])
  ;; if label exists, use it instead of the code fragment
  (printf "~a at line ~a column ~a\n" (or label code) line col)
  (printf "result: ~a\n\n" val)
  ;; return the value itself, so that we can wrap macro around an expression
  ;; without restructuring any code
  val)

(define-simple-macro (debug <x> option ...)
  #:with line (datum->syntax this-syntax (syntax-line #'<x>))
  #:with col (datum->syntax this-syntax (syntax-column #'<x>))
  (debug:core line col (quote <x>) <x> option ...))

(define (add x y)
  (define result (+ x y))
  (debug x)
  (debug y)
  (debug (if #t (+ x y) (error 'impossible)))
  (debug (add1 result) #:label "result plus one")
  (debug result))

(add 2 7)
