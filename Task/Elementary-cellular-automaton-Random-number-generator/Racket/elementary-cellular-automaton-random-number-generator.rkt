#lang racket
;; below is the code from the parent task
(require "Elementary_cellular_automata.rkt")
(require racket/fixnum)

;; This is the RNG automaton
(define (CA30-random-generator
         #:rule [rule 30] ; rule 30 is random, maybe you're interested in using others
         ;; width of the CA... this is implemented as a number of words plus,
         ;; maybe, another word containing the spare bits
         #:bits [bits 256])
  (define-values [full-words more-bits]
    (quotient/remainder bits usable-bits/fixnum))
  (define wrap-rule
    (and (positive? more-bits) (wrap-rule-truncate-left-word more-bits)))
  (define next-gen (CA-next-generation 30 #:wrap-rule wrap-rule))
  (define v (make-fxvector (+ full-words (if more-bits 1 0))))
  (fxvector-set! v 0 1) ; this bit will always have significance

  (define (next-word)
    (define-values [v+ o] (next-gen v 0))
    (begin0 (fxvector-ref v 0) (set! v v+)))

  (lambda (bits)
    (for/fold ([acc 0]) ([_ (in-range bits)])
      ;; the CA is fixnum, but this function returns integers of arbitrary width
      (bitwise-ior (arithmetic-shift acc 1) (bitwise-and (next-word) 1)))))

(module+ main
  ;; To match the other examples on this page, the automaton is 30+30+4 bits long
  ;; (i.e. 64 bits)
  (define C30-rand-64 (CA30-random-generator #:bits 64))
  ;; this should be the list from "C"
  (for/list ([i 10]) (C30-rand-64 8))

  ; we also do big numbers...
  (number->string (C30-rand-64 256) 16)
  (number->string (C30-rand-64 256) 16)
  (number->string (C30-rand-64 256) 16)
  (number->string (C30-rand-64 256) 16))
