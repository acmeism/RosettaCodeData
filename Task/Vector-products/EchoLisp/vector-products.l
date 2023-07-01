(lib 'math)

(define (scalar-triple-product a b c)
  (dot-product a (cross-product b c)))

(define (vector-triple-product a b c)
  (cross-product a (cross-product b c)))

(define a #(3 4 5))
(define b #(4 3 5))
(define c #(-5 -12 -13))

(cross-product a b)
    → #( 5 5 -7)
(dot-product a b)
    → 49
(scalar-triple-product a b c)
    → 6
(vector-triple-product a b c)
    → #( -267 204 -3)
