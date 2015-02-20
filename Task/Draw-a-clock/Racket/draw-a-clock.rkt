#lang racket/gui

(require racket/date slideshow/pict)

(define (clock h m s [r 100])
  (define (draw-hand length angle
                     #:width [width 1]
                     #:color [color "black"])
    (dc (λ (dc dx dy)
          (define old-pen (send dc get-pen))
          (send dc set-pen (new pen% [width width] [color color]))
          (send dc draw-line
                (+ dx r) (+ dy r)
                (+ dx r (* length (sin angle)))
                (+ dy r (* length (cos angle))))
          (send dc set-pen old-pen))
      (* 2 r) (* 2 r)))
  (cc-superimpose
   (for/fold ([pict (circle (* 2 r))])
             ([angle (in-range 0 (* 2 pi) (/ pi 6))]
              [hour (cons 12 (range 1 12))])
     (define angle* angle)
     (define r* (* r 0.8))
     (define txt (text (number->string hour) '(bold . "Helvetica")))
     (define x (- (* r* (sin angle*)) (/ (pict-width txt) 2)))
     (define y (+ (* r* (cos angle*)) (/ (pict-height txt) 2)))
     (pin-over pict (+ r x) (- r y) txt))
   (draw-hand (* r 0.7) (+ pi (* (modulo h 12) (- (/ pi 6))))
              #:width 3)
   (draw-hand (* r 0.5) (+ pi (* m (- (/ pi 30))))
              #:width 2)
   (draw-hand (* r 0.7) (+ pi (* s (- (/ pi 30))))
              #:color "red")
   (disk (* r 0.1))))

(define f (new frame% [label "Clock"] [width 300] [height 300]))

(define c
  (new canvas%
       [parent f]
       [paint-callback
        (λ (c dc)
          (define date (current-date))
          (draw-pict (clock (date-hour date)
                            (date-minute date)
                            (date-second date)
                            (/ (send c get-width) 2))
                     dc 0 0))]))

(define t
  (new timer%
       [notify-callback (λ () (send c refresh-now))]
       [interval 1000]))

(send f show #t)
