#lang racket

(define current-not-found-handler
  (make-parameter (λ (idx max) (raise-range-error 'substitute-template "integer?" "" idx 0 max))))

(define ((substitute-template template) payloads)
  (define match-function
    (match-lambda
      [(? nonnegative-integer? idx) #:when (< idx (length payloads)) (list-ref payloads idx)]
      [(? nonnegative-integer? idx) ((current-not-found-handler) idx (sub1 (length payloads)))]
      [(list (app match-function substitutions) ...) substitutions]))
  (match-function template))

(module+ test
  (require rackunit)

  (define substitute-in-t (substitute-template '(((1 2)
                                                  (3 4 1)
                                                  5))))

  (define p '(Payload#0 Payload#1 Payload#2 Payload#3 Payload#4 Payload#5 Payload#6))

  (check-equal? (substitute-in-t p)
                '(((Payload#1 Payload#2)
                   (Payload#3 Payload#4 Payload#1)
                   Payload#5)))

  (define out-of-bounds-generating-template-substitution (substitute-template '(7)))

  (check-exn exn:fail:contract? (λ () (out-of-bounds-generating-template-substitution p)))

  (parameterize ((current-not-found-handler (λ (idx max) (format "?~a" idx))))
    (check-equal? (out-of-bounds-generating-template-substitution p) '("?7"))))
