#lang racket
;; Delegates. Tim Brown 2014-10-16

(define delegator%
  (class object%
    (init-field [delegate #f])
    (define/public (operation)
      (cond [(and (object? delegate) (object-method-arity-includes? delegate 'thing 0))
             (send delegate thing)]
            [else "default implementation"]))
    (super-new)))

(define non-thinging-delegate% (class object% (super-new)))

(define thinging-delegate%
  (class object%
    (define/public (thing) "delegate implementation")
    (super-new)))

(module+ test
  (require tests/eli-tester)
  (define delegator-1 (new delegator%))
  (define delegator-2 (new delegator%))
  (define non-thinging-delegate (new non-thinging-delegate%))
  (define thinging-delegate     (new thinging-delegate%))

  (test
   (send delegator-1 operation) => "default implementation"
   (send delegator-2 operation) => "default implementation"
   (set-field! delegate delegator-1 non-thinging-delegate) => (void)
   (set-field! delegate delegator-2 thinging-delegate)     => (void)
   (send delegator-1 operation) => "default implementation"
   (send delegator-2 operation) => "delegate implementation"
   (send (new delegator% [delegate thinging-delegate]) operation) => "delegate implementation"))
