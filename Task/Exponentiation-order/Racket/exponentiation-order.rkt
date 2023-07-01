#lang racket
;; 5**3**2 depends on associativity of ** : Racket's (scheme's) prefix function
;; calling syntax only allows for pairs of arguments for expt.

;; So no can do for 5**3**2
;; (5**3)**2
(displayln "prefix")
(expt (expt 5 3) 2)
;; (5**3)**2
(expt 5 (expt 3 2))

;; There is also a less-used infix operation (for all functions, not just expt)... which I suppose
;; might do with an airing. But fundamentally nothing changes.
(displayln "\"in\"fix")
((5 . expt . 3) . expt .  2)
(5  . expt . (3 . expt . 2))

;; everyone's doing a reduction, it seems
(displayln "reduction")
(require (only-in srfi/1 reduce reduce-right))
(reduce expt 1 '(5 3 2))
(reduce-right expt 1 '(5 3 2))
