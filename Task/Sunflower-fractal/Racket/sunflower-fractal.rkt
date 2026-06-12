#lang racket

(require 2htdp/image)

(define N 3000)
(define DISK-RATIO 0.5)
(define factor (+ 0.5 (sqrt 1.25)))
(define WIDTH 500)
(define HEIGHT 500)
(define max-rad (/ (expt N factor) N))

(for/fold ([image (empty-scene WIDTH HEIGHT)]) ([i (in-range N)])
  (define r (/ (expt i factor) N))
  (define color (if (< (/ r max-rad) DISK-RATIO) 'brown 'darkyellow))
  (define theta (* 2 pi factor i))
  (place-image (circle (* 10 i (/ 1 N)) 'outline color)
               (+ (/ WIDTH 2) (* r (sin theta)))
               (+ (/ HEIGHT 2) (* r (cos theta)))
               image))
