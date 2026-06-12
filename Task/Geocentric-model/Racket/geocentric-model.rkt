#lang racket

(require 2htdp/universe
         2htdp/image)

(define WIDTH 800)
(define HEIGHT 800)
(define CX (/ WIDTH 2))
(define CY (/ HEIGHT 2))

(define planets
  (list
   (list "Moon"     70   0.01  6  0 "light grey")
   (list "Mercury" 120   0.008 5  0 "grey")
   (list "Venus"   170   0.006 9  0 "yellow")
   (list "Sun"     230   0.004 18 0 "orange")
   (list "Mars"    300   0.003 7  0 "red")
   (list "Jupiter" 360   0.002 15 0 "brown")))

(define (update-planet p)
  (match p
    [(list name dist speed size angle color)
     (list name dist speed size (+ angle speed) color)]))

(define (update-world w)
  (map update-planet w))

(define (draw-planet p img)
  (match p
    [(list name dist speed size angle color)
     (define px (+ CX (* (cos angle) dist)))
     (define py (+ CY (* (sin angle) dist)))
     (place-image
      (text name 12 "white")
      (+ px size 10) py
      (place-image
       (circle size "solid" color)
       px py
       img))]))

(define (draw-orbit p img)
  (match p
    [(list _ dist _ _ _ _)
     (place-image
      (circle dist "outline" "gray")
      CX CY img)]))

(define (draw-world w)
  (foldl draw-planet
         (foldl draw-orbit
                (rectangle WIDTH HEIGHT "solid" "black")
                w)
         w))

(big-bang planets
  (on-tick update-world 0.016)
  (to-draw draw-world))
