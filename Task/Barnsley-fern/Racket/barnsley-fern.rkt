#lang racket

(require racket/draw)

(define fern-green (make-color #x32 #xCD #x32 0.66))

(define (fern dc n-iterations w h)
  (for/fold ((x #i0) (y #i0))
            ((i n-iterations))
    (define-values (x′ y′)
      (let ((r (random)))
        (cond
          [(<= r 0.01) (values 0
                               (* y 16/100))]
          [(<= r 0.08) (values (+ (* x 20/100) (* y -26/100))
                               (+ (* x 23/100) (* y 22/100) 16/10))]
          [(<= r 0.15) (values (+ (* x -15/100) (* y 28/100))
                               (+ (* x 26/100) (* y 24/100) 44/100))]
          [else (values (+ (* x 85/100) (* y 4/100))
                        (+ (* x -4/100) (* y 85/100) 16/10))])))

    (define px (+ (/ w 2) (* x w 1/11)))
    (define py (- h (* y h 1/11)))
    (send dc set-pixel (exact-round px) (exact-round py) fern-green)
    (values x′ y′)))


(define bmp (make-object bitmap% 640 640 #f #t 2))

(fern (new bitmap-dc% [bitmap bmp]) 200000 640 640)

bmp
(send bmp save-file "images/racket-barnsley-fern.png" 'png)
