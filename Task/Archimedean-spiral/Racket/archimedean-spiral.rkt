#lang racket/base
(require plot
         racket/math)

;; x and y bounds set to centralise the circle
(define (archemedian-spiral-renderer2d a b θ/τ-max
                                       #:samples (samples (line-samples)))
  (define (f θ) (+ a (* b θ)))
  (define max-dim (+ a (* θ/τ-max 2 pi b)))
  (polar f
      0 (* θ/τ-max 2 pi)
      #:x-min (- max-dim)
      #:x-max max-dim
      #:y-min (- max-dim)
      #:y-max  max-dim
      #:samples samples))

(plot (list (archemedian-spiral-renderer2d 0.0 24  4)))

;; writes to a file so hopefully, I can post it to RC...
(plot-file (list (archemedian-spiral-renderer2d 0.0 24  4))
           "images/archemidian-spiral-racket.png")
