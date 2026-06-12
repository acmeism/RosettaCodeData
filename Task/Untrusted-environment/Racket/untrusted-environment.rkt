#lang racket
(require racket/sandbox)
(define e (make-evaluator 'racket))
(e '(...unsafe code...))
