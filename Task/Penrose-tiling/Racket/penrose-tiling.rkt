#lang racket

(require racket/draw)

(define rules '([M . (O A + + P A - - - - N A < - O A - - - - M A > + +)]
                [N . (+ O A - - P A < - - - M A - - N A > +)]
                [O . (- M A + + N A < + + + O A + + P A > -)]
                [P . (- - O A + + + + M A < + P A + + + + N A > - - N A)]
                [S . (< N > + + < N > + + < N > + + < N > + + < N >)]))

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
  (for/fold ([x 160] [y 160] [θ (/ pi 5)] [S '()])
            ([cmd (in-list (get-cmds N 'S))])
    (define (draw/values x* y* θ* S*)
      (send/apply dc draw-line (map (curry + OFFSET) (list x y x* y*)))
      (values x* y* θ* S*))
    (match cmd
      ['A (draw/values (+ x (* R (cos θ))) (+ y (* R (sin θ))) θ S)]
      ['+ (values x y (+ θ (/ pi 5)) S)]
      ['- (values x y (- θ (/ pi 5)) S)]
      ['<  (values x y θ (cons (list x y θ) S))]
      ['> (match-define (cons (list x y θ) S*) S)
          (values x y θ S*)]
      [_ (values x y θ S)]))
  target)

(make-curve 500 4 20 80 (make-color 255 255 0) (make-color 0 0 0))
