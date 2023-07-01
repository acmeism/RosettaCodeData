#lang racket
;;  from lisp (cos I could just lift the code)
(require images/flomap
         2htdp/universe
         racket/flonum)

;; copied from pythagoras-triangle#racket
(define (real-remainder x q) (- x (* (floor (/ x q)) q)))

(define (HSV->RGB H S V)
  (define C (* V S)) ; chroma
  (define H′ (/ H 60))
  (define X (* C (- 1 (abs (- (real-remainder H′ 2) 1)))))
  (define-values (R1 G1 B1)
    (cond
      [(< H′ 1) (values C X 0.)]
      [(< H′ 2) (values X C 0.)]
      [(< H′ 3) (values 0. C X)]
      [(< H′ 4) (values 0. X C)]
      [(< H′ 5) (values X 0. C)]
      [(< H′ 6) (values C 0. X)]
      [else (values 0. 0. 0.)]))
  (define m (- V C))
  (values (+ R1 m) (+ G1 m) (+ B1 m)))


(define ((colour-component-by-pos ϕ) k x y)
  (let ((rv
         (/ (+ (+ 1/2 (* 1/2 (sin (+ ϕ (/ x 16.0)))))
               (+ 1/2 (* 1/2 (sin (+ ϕ (/ y 8.0)))))
               (+ 1/2 (* 1/2 (sin (+ ϕ (/ (+ x y) 16.0)))))
               (+ 1/2 (* 1/2 (sin (+ ϕ (/ (sqrt (+ (sqr x) (sqr y))) 8.0))))))
            4.0)))
    rv))

(define ((plasma-flomap (ϕ 0)) w h)
  (build-flomap 1 w h (colour-component-by-pos ϕ)))

(define ((plasma-image (ϕ 0)) w h)
  (flomap->bitmap ((plasma-flomap ϕ) w h)))

(define ((colour-plasma plsm) t)
  (let ((w (flomap-width plsm))
        (h (flomap-height plsm)))
    (flomap->bitmap
     (build-flomap* 3 w h
                    (λ (x y)
                      (define-values (r g b)
                        (HSV->RGB (real-remainder
                                   (+ (* t 5.)
                                      (* 360 (flomap-ref plsm 0 x y)))
                                   360.) 1. 1.))
                      (flvector r g b))))))

;((plasma-image) 200 200)

;((plasma-image (/ pi 32)) 200 200)

(define plsm ((plasma-flomap) 300 300))
  (animate (λ (t)
             ((colour-plasma plsm) t)))
