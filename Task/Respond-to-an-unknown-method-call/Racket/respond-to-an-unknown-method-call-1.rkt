#lang racket

(require racket/class)

(define-syntax-rule (send~ obj method x ...)
  ;; note: this is a naive macro, a real one should avoid evaluating `obj' and
  ;; the `xs' more than once
  (with-handlers ([(λ(e) (and (exn:fail:object? e)
                              ;; only do this if there *is* an `unknown-method'
                              (memq 'unknown-method (interface->method-names
                                                     (object-interface o)))))
                   (λ(e) (send obj unknown-method 'method x ...))])
    (send obj method x ...)))

(define foo%
  (class object%
    (define/public (foo x)
      (printf "foo: ~s\n" x))
    (define/public (unknown-method name . xs)
      (printf "Unknown method ~s: ~s\n" name xs))
    (super-new)))

(define o (new foo%))
(send~ o foo 1) ; => foo: 1
(send~ o whatever 1) ; Unknown method whatever: (1)
