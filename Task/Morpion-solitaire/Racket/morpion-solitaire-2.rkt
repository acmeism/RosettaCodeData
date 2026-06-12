(module render racket
  (require racket/match
           racket/draw
           pict
          (submod ".." rules))
  (provide display-state
           render-state)

  (define (min/max-point-coords p#)
    (for/fold ((min-x #f) (min-y #f) (max-x #f) (max-y #f))
              ((k (in-hash-keys p#)))
      (match-define (cons x y) k)
      (if min-x
          (values (min min-x x) (min min-y y) (max max-x x) (max max-y y))
          (values x y x y))))

  (define (draw-text/centered dc x y t ->x ->y)
    (define-values (w h b v) (send dc get-text-extent t))
    (send dc draw-text t (- (->x x) (* w 1/2)) (- (->y y) (* h 1/2))))

  (define ((with-stored-dc-context draw-fn) dc w h)
    (define old-brush (send dc get-brush))
    (define old-pen (send dc get-pen))
    (define old-font (send dc get-font))
    (draw-fn dc w h)
    (send* dc (set-brush old-brush) (set-pen old-pen) (set-font old-font)))

  (define red-brush (new brush% [style 'solid] [color "red"]))
  (define white-brush (new brush% [style 'solid] [color "white"]))
  (define cyan-brush (new brush% [style 'solid] [color "cyan"]))
  (define cyan-pen (new pen% [color "cyan"]))
  (define black-pen (new pen% [color "black"]))
  (define green-pen (new pen% [color "green"] [width 3]))
  (define black-brush (new brush% [style 'solid] [color "black"]))

  (define (render-state p# ls (o# (hash)))
    (define-values (min-x min-y max-x max-y) (min/max-point-coords p#))
    (define C 24)
    (define R  8)
    (define D (* R 2))
    (define Rp 4)

    (define (draw dc w h)
      (define (->x x) (* C (- x min-x -1/2)))
      (define (->y y) (* C (- y min-y -1/2 )))
      (send dc set-brush cyan-brush)
      (send dc set-pen cyan-pen)
      (send dc set-font (make-object font% R 'default))

      (for ((y (in-range min-y (add1 max-y))))
        (send dc draw-line (->x min-x) (->y y) (->x max-x) (->y y))
        (for ((x (in-range min-x (add1 max-x))))
          (send dc draw-line (->x x) (->y min-y) (->x x) (->y max-y))))

      (send dc set-pen black-pen)
      (for ((l (in-list ls)))
        (match-define (vector x y d (cons ex ey)) l)
        (define-values (dx dy) (line-dx.dy d))
        (define x1 (+ x (* 4 dx)))
        (define y1 (+ y (* 4 dy)))
        (send* dc (draw-line (->x x) (->y y) (->x x1) (->y y1))))

      (for* ((y (in-range min-y (add1 max-y)))
             (x (in-range min-x (add1 max-x))))
        (define k (cons x y))
        (cond [(hash-has-key? o# k)
               (send dc set-brush red-brush)
               (send dc draw-ellipse (- (->x x) R) (- (->y y) R) D D)]
              [(hash-has-key? p# k)
               (send dc set-brush white-brush)
               (send dc draw-ellipse (- (->x x) R) (- (->y y) R) D D)]))

      (send dc set-brush black-brush)
      (for ((l (in-list ls))
            (i (in-naturals 1)))
        (match-define (vector _ _ d (cons ex ey)) l)
        (define-values (dx dy) (line-dx.dy d))
        (define R.dx (* R dx 0.6))
        (define R.dy (* R dy 0.6))
        (send* dc
          (set-pen green-pen)
          (draw-line (- (->x ex) R.dx) (- (->y ey) R.dy) (+ (->x ex) R.dx) (+ (->y ey) R.dy))
          (set-pen black-pen))
        (draw-text/centered dc ex ey (~a i) ->x ->y)))

    (define P (dc (with-stored-dc-context draw) (* C (- max-x min-x -1)) (* C (- max-y min-y -1))))
    (printf "~s~%~a points ~a lines~%" ls (hash-count p#) (length ls))
    P)

  (define (display-state p# l (o# (hash)))
    (define-values (min-x min-y max-x max-y) (min/max-point-coords p#))
    (for ((y (in-range min-y (add1 max-y)))
          #:when (unless (= y min-y) (newline))
          (x (in-range min-x (add1 max-x))))
      (define k (cons x y))
      (write-char
       (cond [(hash-has-key? o# k) #\+]
             [(hash-has-key? p# k) #\.]
             [else #\space])))
    (printf "~s~%~a points ~a lines~%" l (hash-count p#) (length l))))
