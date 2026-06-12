#lang racket
(require rnrs/arithmetic/bitwise-6)
(for/list ([n 20])
  (define x (expt 42 n))
  (list n (bitwise-first-bit-set x) (- (integer-length x) 1)))
