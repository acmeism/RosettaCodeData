#lang racket
(require ffi/unsafe)
((get-ffi-obj 'daemon #f (_fun _int _int -> _int)) 0 0)
(with-output-to-file "/tmp/foo"
  (λ() (for ([i 10]) (displayln (random 1000)) (flush-output) (sleep 1))))
