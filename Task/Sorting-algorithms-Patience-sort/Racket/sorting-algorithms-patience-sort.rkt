#lang racket/base
(require racket/match racket/list)

;; the car of a pile is the "bottom", i.e. where we place a card
(define (place-greedily ps-in c <?)
  (let inr ((vr null) (ps ps-in))
    (match ps
      [(list) (reverse (cons (list c) vr))]
      [(list (and psh (list ph _ ...)) pst ...)
       #:when (<? c ph) (append (reverse (cons (cons c psh) vr)) pst)]
      [(list psh pst ...) (inr (cons psh vr) pst)])))

(define (patience-sort cs-in <?)
  ;; Scatter
  (define piles
    (let scatter ((cs cs-in) (ps null))
      (match cs [(list) ps] [(cons a d) (scatter d (place-greedily ps a <?))])))
  ;; Gather
  (let gather ((rv null) (ps piles))
    (match ps
      [(list) (reverse rv)]
      [(list psh pst ...)
       (let scan ((least psh) (seens null) (unseens pst))
         (define least-card (car least))
         (match* (unseens least)
           [((list) (list l)) (gather (cons l rv) seens)]
           [((list) (cons l lt)) (gather (cons l rv) (cons lt seens))]
           [((cons (and ush (cons u _)) ust) (cons l _))
            #:when (<? l u) (scan least (cons ush seens) ust)]
           [((cons ush ust) least) (scan ush (cons least seens) ust)]))])))

(patience-sort (shuffle (for/list ((_ 10)) (random 7))) <)
