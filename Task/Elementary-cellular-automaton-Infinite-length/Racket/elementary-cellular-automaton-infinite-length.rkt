#lang racket
; below is the code from the parent task
(require "Elementary_cellular_automata.rkt")
(require racket/fixnum)

(define (wrap-rule-infinite v-in vl-1 offset)
  (define l-bit-set? (bitwise-bit-set? (fxvector-ref v-in 0) usable-bits/fixnum-1))
  (define r-bit-set? (bitwise-bit-set? (fxvector-ref v-in vl-1) 0))
  ;; if we need to extend left offset is reduced by 1
  (define l-pad-words (if l-bit-set? 1 0))
  (define r-pad-words (if r-bit-set? 1 0))
  (define new-words (fx+ l-pad-words r-pad-words))
  (cond
    [(fx= 0 new-words) (values v-in vl-1 offset)] ; nothing changes
    [else
     (define offset- (if l-bit-set? (fx- offset 1) offset))
     (define l-sequence (if l-bit-set? (in-value 0) (in-sequences)))
     (define vl-1+ (fx+ vl-1 (fx+ l-pad-words r-pad-words)))
     (define v-out
       (for/fxvector
           #:length (fx+ vl-1+ 1) #:fill 0 ; right padding
           ([f (in-sequences l-sequence (in-fxvector v-in))])
        f))
     (values v-out vl-1+ offset-)]))

(module+ main
  (define ng/90/infinite (CA-next-generation 90 #:wrap-rule wrap-rule-infinite))
  (for/fold ([v (fxvector #b10000000000000000000)]
             [o 1]) ; start by pushing output right by one
            ([step (in-range 40)])
    (show-automaton v #:step step #:push-right o)
    (newline)
    (ng/90/infinite v o)))
