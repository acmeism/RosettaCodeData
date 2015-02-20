(require 2htdp/image)

(define/match (point v)
  [{(vector x y)} (λ (s) (place-image (circle 2 "solid" "black") x y s))])

(define/match (circ v r)
  [{(vector x y) r} (λ (s) (place-image (circle r "outline" "red") x y s))])

(define p1 #(40 50))
(define p2 #(60 30))
(define r 20)
(define-values (x1 x2) (circle-centers p1 p2 r))

((compose (point p1) (point p2) (circ x1 r) (circ x2 r))
 (empty-scene 100 100))
