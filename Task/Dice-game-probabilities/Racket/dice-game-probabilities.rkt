#lang racket

(define probs# (make-hash))

(define (NdD n d)
  (hash-ref!
   probs# (cons n d)
   (λ ()
     (cond
       [(= n 0) ; every chance of nothing!
        (hash 0 1)]
       [else
        (for*/fold ((hsh (hash))) (((i p) (in-hash (NdD (sub1 n) d))) (r (in-range 1 (+ d 1))))
          (hash-update hsh (+ r i) (λ (p+) (+ p+ (/ p d))) 0))]))))

(define (game-probs N1 D1 N2 D2)
  (define P1 (NdD N1 D1))
  (define P2 (NdD N2 D2))
  (define-values (W D L)
    (for*/fold ((win 0) (draw 0) (lose 0)) (((r1 p1) (in-hash P1)) ((r2 p2) (in-hash P2)))
      (define p (* p1 p2))
      (cond
        [(< r1 r2) (values win draw (+ lose p))]
        [(= r1 r2) (values win (+ draw p) lose)]
        [(> r1 r2) (values (+ win p) draw lose)])))

  (printf "P(P1 win): ~a~%" (real->decimal-string W 6))
  (printf "P(draw):   ~a~%" (real->decimal-string D 6))
  (printf "P(P2 win): ~a~%" (real->decimal-string L 6))
  (list W D L))

(printf "GAME 1 (9D4 vs 6D6)~%")
(game-probs 9 4 6 6)
(newline)

(printf "GAME 2 (5D10 vs 6D7) [what is a D7?]~%")
(game-probs 5 10 6 7)
