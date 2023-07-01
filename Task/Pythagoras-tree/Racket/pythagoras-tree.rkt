#lang racket
(require racket/draw pict)

(define (draw-pythagoras-tree order x0 y0 x1 y1)
  (λ (the-dc dx dy)
    (define (inr order x0 y0 x1 y1)
      (when (positive? order)
        (let* ((y0-1 (- y0 y1))
               (x1-0 (- x1 x0))
               (x2 (+ x1 y0-1))
               (y2 (+ y1 x1-0))
               (x3 (+ x0 y0-1))
               (y3 (+ y0 x1-0))
               (x4 (+ x2 x3 (/ (+ x0 x2) -2)))
               (y4 (+ y2 y3 (/ (+ y0 y2) -2)))
               (path (new dc-path%)))
          (send* path [move-to x0 y0]
            [line-to x1 y1] [line-to x2 y2] [line-to x3 y3]
            [close])
          (send the-dc draw-path path dx dy)
          (inr (sub1 order) x3 y3 x4 y4)
          (inr (sub1 order) x4 y4 x2 y2))))

    (define old-brush (send the-dc get-brush))
    (define old-pen (send the-dc get-pen))
    (send the-dc set-pen (new pen% [width 1] [color "black"]))
    (inr (add1 order) x0 y0 x1 y1)
    (send the-dc set-brush old-brush)
    (send the-dc set-pen old-pen)))

(dc (draw-pythagoras-tree 7 (+ 200 32) 255 (- 200 32) 255) 400 256)
