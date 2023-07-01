#lang racket

(require racket/draw)

(define rules '([A . (- B F + A F A + F B -)]
                [B . (+ A F - B F B - F A +)]))

(define (get-cmds n cmd)
  (cond
    [(= 0 n) (list cmd)]
    [else (append-map (curry get-cmds (sub1 n))
                      (dict-ref rules cmd (list cmd)))]))

(define (make-curve DIM N R OFFSET COLOR BACKGROUND-COLOR)
  (define target (make-bitmap DIM DIM))
  (define dc (new bitmap-dc% [bitmap target]))
  (send dc set-background BACKGROUND-COLOR)
  (send dc set-pen COLOR 1 'solid)
  (send dc clear)
  (for/fold ([x 0] [y 0] [θ (/ pi 2)])
            ([cmd (in-list (get-cmds N 'A))])
    (define (draw/values x* y* θ*)
      (send/apply dc draw-line (map (curry + OFFSET) (list x y x* y*)))
      (values x* y* θ*))
    (match cmd
      ['F (draw/values (+ x (* R (cos θ))) (+ y (* R (sin θ))) θ)]
      ['+ (values x y (+ θ (/ pi 2)))]
      ['- (values x y (- θ (/ pi 2)))]
      [_  (values x y θ)]))
  target)

(make-curve 500 6 7 30 (make-color 255 255 0) (make-color 0 0 0))
