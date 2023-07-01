;; Based on Mandelbrot code (GPL) from:
;;  https://github.com/hebr3/Mandelbrot-Set-Racket/blob/master/Mandelbrot.v6.rkt
;; Julia set algoithm (and coloring) from:
;;  http://lodev.org/cgtutor/juliamandelbrot.html
;; HSV code (GPL) based on:
;;  https://github.com/takikawa/pict-utils/blob/master/pict-utils/hsv.rkt

#lang racket

;; Required to generate image
(require picturing-programs)

;; CONSTANTS - NUMBERS
(define DEPTH  300)
(define WIDTH  800)
(define HEIGHT 600)

;; Structures
(struct posn [x y] #:transparent)

;; CONSTANTS - GRAPHIC
(define BACKGROUND (rectangle WIDTH HEIGHT 'solid 'grey))
(define jcnst (posn -0.7 0.27015))

;; PROCEDURES
;; make an RGB color from HSV values
(define (make-color/hsv hue saturation value)
  (define chroma (* saturation value))
  (define hue* (/ (remainder* hue (* 2 pi)) (/ pi 3)))
  (define X (* chroma (- 1 (abs (- (remainder* hue* 2) 1)))))
  (define-values (r1 g1 b1)
    (cond [(and (<= 0 hue*) (< hue* 1)) (values chroma X 0)]
          [(and (<= 1 hue*) (< hue* 2)) (values X chroma 0)]
          [(and (<= 2 hue*) (< hue* 3)) (values 0 chroma X)]
          [(and (<= 3 hue*) (< hue* 4)) (values 0 X chroma)]
          [(and (<= 4 hue*) (< hue* 5)) (values X 0 chroma)]
          [(and (<= 5 hue*) (< hue* 6)) (values chroma 0 X)]))
  (define m (- value chroma))
  (apply make-color (map (λ (x) (exact-round (* 255 (+ x m))))
                         (list r1 g1 b1))))

;; general remainder
(define (remainder* n1 n2)
  (define num-divides (/ n1 n2))
  (- n1 (* (floor num-divides) n2)))

;; Posn -> Number
;; Returns the magnitude of the posn
(define (posn-mag pt)
  (let ([pt-x (posn-x pt)]
        [pt-y (posn-y pt)])
    (sqrt (+ (* pt-x pt-x)
                 (* pt-y pt-y)))))

;; Posn Posn -> Posn
;; Posn addition
(define (posn+ pt1 pt2)
  (let ([pt1-x (posn-x pt1)]
        [pt1-y (posn-y pt1)]
        [pt2-x (posn-x pt2)]
        [pt2-y (posn-y pt2)])
    (posn (+ pt1-x pt2-x)
          (+ pt1-y pt2-y))))

;; Posn Posn -> Posn
;; Posn multiplication
(define (posn* pt1 pt2)
  (let ([x1 (posn-x pt1)]
        [y1 (posn-y pt1)]
        [x2 (posn-x pt2)]
        [y2 (posn-y pt2)])
    (posn (- (* x1 x2) (* y1 y2))
          (+ (* x1 y2) (* x2 y1)))))

;; Posn -> Posn
;; Posn square
(define (posn-sqr pt)
  (posn* pt pt))

;; Posn -> Number
;; Returns the julia set  escape number for a given complex number
;; given in rectangular coordinates.
(define (julia-set-number  start)
  (define (iter result count)
    (cond [(> (posn-mag result) 2) (sub1 count)]
          [(> count DEPTH) DEPTH]
          [else (iter (posn+ jcnst (posn-sqr result))
                      (add1 count))]))
  (iter start 1))

;; Number -> Number
;; Returns the scaled location of a point
(define (scaled-x x)
  (/ (* 1.5 (- x (/ WIDTH 2))) (* 0.5 WIDTH)))
(define (scaled-y y)
  (/ (- y (/ HEIGHT 2)) (* 0.5 HEIGHT)))

;; Generates image
(define M-Image
  (map-image
   (λ (x y c)
     (let* ([ref (julia-set-number  (posn (scaled-x x) (scaled-y y)))])
       (cond [(= ref DEPTH) (name->color 'black)]
             [else (make-color/hsv (* 2 (* pi (/ ref DEPTH))) 1 1)]) ))
 BACKGROUND))

M-Image ;show image if using drracket

(save-image M-Image "julias.png")
