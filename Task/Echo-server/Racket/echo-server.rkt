#lang racket

(define listener (tcp-listen 12321))
(let echo-server ()
  (define-values (in out) (tcp-accept listener))
  (thread (λ () (copy-port in out)
                (close-output-port out)))
  (echo-server))
