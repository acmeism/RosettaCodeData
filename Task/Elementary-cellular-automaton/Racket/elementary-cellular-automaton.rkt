#lang racket
(require racket/fixnum)
(provide usable-bits/fixnum usable-bits/fixnum-1 CA-next-generation
         wrap-rule-truncate-left-word show-automaton)

(define usable-bits/fixnum 30)
(define usable-bits/fixnum-1 (sub1 usable-bits/fixnum))
(define usable-bits/mask (fx- (fxlshift 1 usable-bits/fixnum) 1))
(define 2^u-b-1 (fxlshift 1 usable-bits/fixnum-1))
(define (fxior3 a b c) (fxior (fxior a b) c))
(define (if-bit-set n i [result 1]) (if (bitwise-bit-set? n i) result 0))

(define (shift-right-1-bit-with-lsb-L L n)
  (fxior (if-bit-set L 0 2^u-b-1) (fxrshift n 1)))

(define (shift-left-1-bit-with-msb-R n R)
  (fxior (fxand usable-bits/mask (fxlshift n 1))
         (if-bit-set R usable-bits/fixnum-1)))

(define ((CA-next-bit-state rule) L n R)
  (for/fold ([n+ 0])
            ([b (in-range usable-bits/fixnum-1 -1 -1)])
    (define rule-bit (fxior3 (if-bit-set (shift-right-1-bit-with-lsb-L L n) b 4)
                             (if-bit-set n b 2)
                             (if-bit-set (shift-left-1-bit-with-msb-R n R) b)))
    (fxior (fxlshift n+ 1) (if-bit-set rule rule-bit))))

;; CA-next-generation generates a function which takes:
;;  v-in   : an fxvector representing the CA's current state as a bit field. This may be mutated
;;  offset : the offset of the leftmost element of v-in; this is used in infinite CA to allow the CA
;;           to occupy negative indices
;;  wrap-rule : provided for automata that are not an integer number of usable-bits/fixnum bits wide
;;  wrap-rule = #f - v-in and offset are unchanged
;;  wrap-rule : (v-in vl-1 offset) -> (values v-out vl-1+ offset-)
;;             v-in as passed into CA-next-generation
;;             vl-1=(sub1 (length v-in)), since its precomputed vaule is needed
;;             offset as passed into CA-next-generation
;;             v-out: either a new copy of v-in, or v-in itself (which might be mutated)
;;             vl-1+: (sub1 (length v-out))
;;             offset- : a new value for offset (it will have decreased since the CA grows to the left
;;             with offset, and to the right with (length v-out)
(define (CA-next-generation rule #:wrap-rule (wrap-rule values))
  (define next-state (CA-next-bit-state rule))
  (lambda (v-in offset)
    (define vl-1 (fx- (fxvector-length v-in) 1))
    (define-values [v+ v+l-1 offset-] (wrap-rule v-in vl-1 offset))
    (define rv
      (for/fxvector ([l (in-sequences (in-value (fxvector-ref v+ v+l-1)) (in-fxvector v+))]
                     [n (in-fxvector v+)]
                     [r (in-sequences (in-fxvector v+ 1) (in-value (fxvector-ref v+ 0)))])
        (next-state l n r)))
    (values rv offset-)))

;; CA-next-generation with the default (non) wrap rule wraps the MSB of the left-hand word (L) and the
;; LSB of the right-hand word (R) in the CA. If the CA is not a multiple of usable-bits/fixnum wide,
;; then we use this function to put these bits where they can be used... i.e. the actual MSB is copied
;; to the word's MSB and the LSB is copied to the bit that is to the left of the actual MSB.
(define (wrap-rule-truncate-left-word sig-bits)
  (define wlb-mask (fx- (fxlshift 1 sig-bits) 1))
  (unless (fx< sig-bits (fx- usable-bits/fixnum 1))
    (error "we need at least 2 bits in the top of the word to do this safely"))
  (lambda (v-in vl-1 offset)
    (define v0 (fxvector-ref v-in 0))
    ;; this must wrap to wlb of the first word
    (define last-bit (fxlshift (fxand 1 (fxvector-ref v-in vl-1)) sig-bits))
    ;; this must wrap to the extreme left of the first word
    (define first-bit (if-bit-set v0 (fx- sig-bits 1) 2^u-b-1))
    (fxvector-set! v-in 0 (fxior3 last-bit first-bit (fxand v0 wlb-mask)))
    (values v-in vl-1 offset)))

;; This displays a state of the CA
(define (show-automaton v #:step (step #f) #:sig-bits (sig-bits #f) #:push-right (push-right #f))
  (when step (printf "[~a] " (~a #:align 'right #:width 10 step)))
  (when push-right (display (make-string (* usable-bits/fixnum push-right) #\.)))
  (when (number? sig-bits)
    (display (~a #:width sig-bits #:align 'right #:pad-string "0"
                 (number->string (fxvector-ref v 0) 2))))
  (for ([n (in-fxvector v (if sig-bits 1 0))])
    (display (~a #:width usable-bits/fixnum #:align 'right #:pad-string "0" (number->string n 2)))))

(module+ main
  (define ng/122/19-bits (CA-next-generation 122 #:wrap-rule (wrap-rule-truncate-left-word 19)))
  (for/fold ([v (fxvector #b1000000000)] [o 0]) ([step (in-range 40)])
    (show-automaton v #:step step #:sig-bits 19)
    (newline)
    (ng/122/19-bits v o)))
