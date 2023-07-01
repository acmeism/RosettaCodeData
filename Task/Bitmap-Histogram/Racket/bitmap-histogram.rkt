 #lang racket
(require racket/draw math/statistics racket/require
         (filtered-in
          (lambda (name) (regexp-replace #rx"unsafe-" name ""))
          racket/unsafe/ops))

;; CIE formula as discussed in "Greyscale image" task
(define (L r g b)
  ;; In fact there is no need, statistically for L to be divided by 10000
  (fx+ (fx* r 2126) (fx+ (fx* g 7152) (fx* b 722))))

(define (prepare-bytes bm depth load-content?)
  (define w (send bm get-width))
  (define h (send bm get-height))
  (define rv (make-bytes (* w h depth)))
  (define just-alpha? #f)
  (define pre-multiply? #t); let racket cope with alpha-ness
  (when load-content? (send bm get-argb-pixels 0 0 w h rv just-alpha? pre-multiply?))
  rv)

(define (bitmap-histogram bm)
  (unless (send bm is-color?) (error 'bitmap->histogram "bitmap must be colour"))
  (define pxls (prepare-bytes bm 4 #t))
  (define l# (make-hash))
  (for ((r (in-bytes pxls 1 #f 4)) (g (in-bytes pxls 2 #f 4)) (b (in-bytes pxls 3 #f 4)))
    (hash-update! l# (L r g b) add1 0))
  (define xs (hash-keys l#))   ; the colour values
  (define ws (hash-values l#)) ; the "weights" i.e. counts for median
  (values xs ws))

(define (bitmap-quantile q bm (hist-xs #f) (hist-ws #f))
  (define-values (xs ws) (if (and hist-xs hist-ws)
                             (values hist-xs hist-ws)
                             (bitmap-histogram bm)))
  (quantile q < xs ws))

;; we don't return a 1-depth bitmap, so we can do more interesting things with colour
(define (bitmap->monochrome q bm (hist-xs #f) (hist-ws #f))
  (define Q (bitmap-quantile q bm hist-xs hist-ws))
  (define pxls (prepare-bytes bm 4 #t))
  (for ((r (in-bytes pxls 1 #f 4))
        (g (in-bytes pxls 2 #f 4))
        (b (in-bytes pxls 3 #f 4))
        (i (sequence-map (curry fx* 4) (in-naturals))))
    (define l (L r g b))
    (define rgb+ (cond [(fx< l Q) 0] [else 255]))
    (bytes-set! pxls (fx+ i 1) rgb+)
    (bytes-set! pxls (fx+ i 2) rgb+)
    (bytes-set! pxls (fx+ i 3) rgb+))
  (define w (send bm get-width))
  (define h (send bm get-height))
  (define rv (make-bitmap w h #f))
  (send rv set-argb-pixels 0 0 w h pxls)
  rv)

(module+ main
  (define bm (read-bitmap "271px-John_Constable_002.jpg"))
  (define-values (xs ws) (bitmap-histogram bm))
  (void
   (send (bitmap->monochrome 1/4 bm) save-file "histogram-racket-0.25.png" 'png)
   (send (bitmap->monochrome 1/2 bm) save-file "histogram-racket-0.50.png" 'png) ; median
   (send (bitmap->monochrome 3/4 bm xs ws) save-file "histogram-racket-0.75.png" 'png)))
