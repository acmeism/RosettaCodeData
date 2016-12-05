;; By decreasing order of performance
;; 1) user definition : lambda and closure

(define (ucompose f g ) (lambda (x) ( f ( g x))))
(ucompose sin cos)
   → (🔒 λ (_x) (f (g _x)))

;; 2) built-in compose : lambda

(compose sin cos)
   → (λ (_#:g1002) (#apply-compose (#list #cos #sin) _#:g1002))

;; 3) compiled composition

(define (sincos x) (sin (cos x)))
sincos → (λ (_x) (⭕️ #sin (#cos _x)))
