#lang racket

(require ffi/unsafe)

(define (madness v) ; i'm so sorry
   (cast v _racket _gcpointer))
