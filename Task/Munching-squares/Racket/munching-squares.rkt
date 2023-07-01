#lang racket
(require racket/draw)
(define palette (for/vector ([x 256]) (make-object color% 0 0 x)))
(define bm (make-object bitmap% 256 256))
(define dc (new bitmap-dc% [bitmap bm]))
(for* ([x 256] [y 256])
  (define c (vector-ref palette (bitwise-xor x y)))
  (send dc set-pixel x y c))
bm
