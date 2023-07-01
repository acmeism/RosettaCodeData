#lang racket
(require math/bigfloat)

(define (pi/a-g rep)
  (let loop ([a 1.bf]
             [g (bf1/sqrt 2.bf)]
             [z (bf/ 1.bf 4.bf)]
             [n (bf 1)]
             [r 0])
    (if (< r rep)
        (let* ([a-p (bf/ (bf+ a g) 2.bf)]
               [g-p (bfsqrt (bf* a g))]
               [z-p (bf- z (bf* (bfsqr (bf- a-p a)) n))])
          (loop a-p g-p z-p (bf* n 2.bf) (add1 r)))
        (bf/ (bfsqr a) z))))

(parameterize ([bf-precision 100])
  (displayln (bigfloat->string (pi/a-g 5)))
  (displayln (bigfloat->string pi.bf)))

(parameterize ([bf-precision 200])
  (displayln (bigfloat->string (pi/a-g 6)))
  (displayln (bigfloat->string pi.bf)))
