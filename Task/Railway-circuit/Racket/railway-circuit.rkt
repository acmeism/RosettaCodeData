#lang racket

(define-syntax-rule (vector+= v idx i)
  (let ((v′ (vector-copy v))) (vector-set! v′ idx (+ (vector-ref v idx) i)) v′))

;; The nb of right turns in direction i
;; must be = to nb of right turns in direction i+6 (opposite)
(define legal? (match-lambda [(vector a b c d e f a b c d e f) #t] [_ #f]))

;; equal circuits by rotation ?
(define (circuit-eq? Ca Cb)
  (define different? (for/fold ((Cb Cb)) ((i (length Cb))
                                          #:break (not Cb))
                       (and (not (equal? Ca Cb)) (append (cdr Cb) (list (car Cb))))))
  (not different?))

;; generation of circuit C[i] i = 0 .... maxn including straight (may be 0) tracks
(define (walk-circuits C_0 Rct_0 R_0 D_0 maxn straight_0)
  (define (inr C Rct R D n strt)
    (cond
      ;; hit !! legal solution
      [(and (= n maxn) (zero? Rct) (legal? R) (legal? D)) (values (list C) 1)] ; save solution

      [(= n maxn) (values null 0)] ; stop - no more track

      ;; important cutter - not enough right turns
      [(and (not (zero? Rct)) (< (+ Rct maxn) (+ n strt 11))) (values null 0)]

      [else
       (define n+ (add1 n))
       (define (clock x) (modulo x 12))
       ;; play right
       (define-values [Cs-r n-r] (inr (cons 1 C) (clock (add1 Rct)) (vector+= R Rct 1) D n+ strt))
       ;; play left
       (define-values [Cs-l n-l] (inr (cons -1 C) (clock (sub1 Rct)) (vector+= R Rct -1) D n+ strt))
       ;; play straight line (if available)
       (define-values [Cs-s n-s]
         (if (zero? strt)
             (values null 0)
             (inr (cons 0 C) Rct R (vector+= D Rct 1) n+ (sub1 strt))))

       (values (append Cs-r Cs-l Cs-s) (+ n-r n-l n-s))])) ; gather them together
  (inr C_0 Rct_0 R_0 D_0 1 straight_0))

;; generate maxn tracks  [ +  straight])
;; i ( 0 .. 11) * 30° are the possible directions
(define (gen (maxn 20) (straight 0))
  (define R (make-vector 12 0)) ; count number of right turns in direction i
  (vector-set! R 0 1); play starter (always right) into R
  (define D (make-vector 12 0)) ; count number of straight tracks in direction i
  (define-values (circuits count)
    (walk-circuits '(1) #| play starter (always right) |# 1 R D (+ maxn straight) straight))

  (define unique-circuits (remove-duplicates circuits circuit-eq?))
  (printf "gen-counters ~a~%" count)

  (if (zero? straight)
      (printf "Number of circuits C~a : ~a~%" maxn (length unique-circuits))
      (printf "Number of circuits C~a,~a : ~a~%" maxn straight (length unique-circuits)))
  (when (< (length unique-circuits) 20) (for ((c unique-circuits)) (writeln c)))
  (newline))

(module+ test
  (require rackunit)
  (check-true (circuit-eq? '(1 2 3) '(1 2 3)))
  (check-true (circuit-eq? '(1 2 3) '(2 3 1)))
  (gen 12)
  (gen 16)
  (gen 20)
  (gen 24)
  (gen 12 4))
