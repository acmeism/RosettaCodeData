#lang racket

(define current-battle-length (make-parameter 3))

(define cards (string->list (string-append "🂢🂣🂤🂥🂦🂧🂨🂩🂪🂫🂭🂮🂡" "🂲🂳🂴🂵🂶🂷🂸🂹🂺🂻🂽🂾🂱"
                                           "🃂🃃🃄🃅🃆🃇🃈🃉🃊🃋🃍🃎🃁" "🃒🃓🃔🃕🃖🃗🃘🃙🃚🃛🃝🃞🃑")))

(define face (curry hash-ref (for/hash ((c cards) (i (in-naturals))) (values c (+ 2 (modulo i 13))))))

(define (print-draw-result turn-number d1 c1 d2 c2 → (pending null))
  (printf "#~a\t~a ~a ~a\t~a|~a|~a~%" turn-number c1 → c2 (length d1) (length pending)(length d2)))

(define (turn d1 d2 (n 1) (pending null) (battle 0))
  (match* (d1 d2)
    [('() '()) "Game ends in a tie!"]
    [(_ '()) "Player 1 wins."]
    [('() _) "Player 2 wins."]
    [((list c3 d1- ...) (list c4 d2- ...))
     #:when (positive? battle)
     (define pending+ (list* c3 c4 pending))
     (print-draw-result n d1- "🂠" d2- "🂠" "?" pending+)
     (turn d1- d2- (add1 n) pending+ (sub1 battle))]
    [((list (and c1 (app face r)) d1- ...) (list (and c2 (app face r)) d2- ...))
     (define pending+ (list* c1 c2 pending))
     (print-draw-result n d1- c1 d2- c2 #\= pending+)
     (turn d1- d2- (add1 n) pending+ (current-battle-length))]
    [((list (and c1 (app face r1)) d1- ...) (list (and c2 (app face r2)) d2- ...))
     (define spoils (shuffle (list* c1 c2 pending)))
     (define p1-win? (> r1 r2))
     (define d1+ (if p1-win? (append d1- spoils) d1-))
     (define d2+ (if p1-win? d2- (append d2- spoils)))
     (print-draw-result n d1+ c1 d2+ c2 (if p1-win? "←" "→"))
     (turn d1+ d2+ (add1 n))]))

(define (war-card-game)
  (call-with-values (λ () (split-at (shuffle cards) (quotient (length cards) 2)))
                    turn))

(displayln (war-card-game))
