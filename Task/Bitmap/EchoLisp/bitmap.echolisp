(lib 'plot)
(define width 600)
(define height 400)

(plot-size width height) ;; set image size

(define (blue x y) (rgb 0.0 0.0 1.0)) ;; a constant function
(plot-rgb blue 1 1) ;; blue everywhere

(lib 'types) ;; uint32 and uint8 vector types

;; bit-map pixel access
(define bitmap (pixels->uint32-vector)) ;; screen to vector of int32
    → 240000

(define (pix-at x y) (vector-ref bitmap (+ x (* y width))))
(rgb->list (pix-at 100 200)) → (0 0 255 255)  ;; rgb blue

;; writing to bitmap
(define (set-color-xy x y col) (vector-set! bitmap (+ x (* y width)) col))

(for* ((x 100)(y 200)) (set-color-xy x y (rgb 1 1 0))) ;; to bitmap
(vector->pixels bitmap) ;; bitmap to screen


;; bit-map color components (r g b a) = index (0 1 2 3) access
(define bitmap (pixels->uint8-clamped-vector)) ;; screen to vector of uint8
(vector-length bitmap)
    → 960000
(define (blue-at-xy x y) (vector-ref bitmap (+ x 3 (* y width)))) ;; 3 = blue component
(blue-at-xy 100 200)
    → 255
