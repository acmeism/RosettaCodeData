#lang racket
(require srfi/1)

(define current-samples (make-parameter 10000))
(define *prisoners* 100)
(define *max-guesses* 50)

(define (evaluate-strategy instance-solved? strategy (s (current-samples)))
  (/ (for/sum ((_ s) #:when (instance-solved? strategy)) 1) s))

(define (build-drawers)
  (list->vector (shuffle (range *prisoners*))))

(define (100-prisoners-problem strategy)
  (every (strategy (build-drawers)) (range *prisoners*)))

(define ((strategy-1 drawers) p)
  (any (λ (_) (= p (vector-ref drawers (random *prisoners*)))) (range *max-guesses*)))

(define ((strategy-2 drawers) p)
  (define-values (_ found?)
    (for/fold ((d p) (found? #f)) ((_ *max-guesses*)) #:break found?
      (let ((card (vector-ref drawers d))) (values card (= card p)))))
  found?)

(define (print-sample-percentage caption f (s (current-samples)))
  (printf "~a: ~a%~%" caption (real->decimal-string (* 100 f) (- (order-of-magnitude s) 2))))

(module+ main
  (print-sample-percentage "random" (evaluate-strategy 100-prisoners-problem strategy-1))
  (print-sample-percentage "optimal" (evaluate-strategy 100-prisoners-problem strategy-2)))
