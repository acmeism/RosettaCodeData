;;;-------------------------------------------------------------------

(import (scheme base))
(import (scheme file))
(import (scheme inexact))
(import (scheme process-context))
(import (scheme write))

;; (srfi 160 f32) is more properly known as (scheme vector f32), but
;; is not part of R7RS-small. The following will work in both Gauche
;; and CHICKEN Schemes.
(import (srfi 160 f32))

;;;-------------------------------------------------------------------

(define-record-type <color>
  (make-color r g b)
  color?
  (r color-r)
  (g color-g)
  (b color-b))

;;; See https://yeun.github.io/open-color/
(define violet9 (make-color (/ #x5F 255.0)
                            (/ #x3D 255.0)
                            (/ #xC4 255.0)))

;;;-------------------------------------------------------------------

(define-record-type <drawing-surface>
  (drawing-surface% u0 v0 u1 v1 pixels)
  drawing-surface?
  (u0 u0%)
  (v0 v0%)
  (u1 u1%)
  (v1 v1%)
  (pixels pixels%))

(define (make-drawing-surface u0 v0 u1 v1)
  (unless (and (<= u0 u1) (<= v0 v1))
    (error "illegal drawing-surface corners"))
  (let ((width (- u1 u0 -1))
        (height (- v1 v0 -1)))
    (let ((pixels (make-f32vector (* width height) 0.0)))
      (drawing-surface% u0 v0 u1 v1 pixels))))

;;; In calls to drawing-surface-ref and drawing-surface-set! indices
;;; outside the drawing_surface are allowed. Such indices are treated
;;; as if you were trying to draw on the air.

(define (drawing-surface-ref s x y)
  (let ((u0 (u0% s))
        (v0 (v0% s))
        (u1 (u1% s))
        (v1 (v1% s)))
    (if (and (<= u0 x) (<= x u1) (<= v0 y) (<= y v1))
        (f32vector-ref (pixels% s)
                       (+ (* (- x u0) (- v1 v0 -1)) (- v1 y)))
        +nan.0)))

(define (drawing-surface-set! s x y opacity)
  (let ((u0 (u0% s))
        (v0 (v0% s))
        (u1 (u1% s))
        (v1 (v1% s)))
    (when (and (<= u0 x) (<= x u1) (<= v0 y) (<= y v1))
      (f32vector-set! (pixels% s)
                      (+ (* (- x u0) (- v1 v0 -1)) (- v1 y))
                      opacity))))

(define (write-PAM s color)
  ;; Write a Portable Arbitrary Map to the current output port, using
  ;; the given color as the foreground color and the drawing-surface
  ;; values as opacities.

  (define (float->byte v) (exact (round (* 255 v))))

  (define r (float->byte (color-r color)))
  (define g (float->byte (color-g color)))
  (define b (float->byte (color-b color)))

  (define w (- (u1% s) (u0% s) -1))
  (define h (- (v1% s) (v0% s) -1))
  (define opacities (pixels% s))

  (define (loop x y)
    (cond ((= y h) )
          ((= x w) (loop 0 (+ y 1)))
          (else
           (let ((alpha (float->byte
                         (f32vector-ref opacities (+ (* x h) y)))))
             (write-bytevector (bytevector r g b alpha))
             (loop (+ x 1) y)))))

  (display "P7") (newline)
  (display "WIDTH ") (display (- (u1% s) (u0% s) -1)) (newline)
  (display "HEIGHT ") (display (- (v1% s) (v0% s) -1)) (newline)
  (display "DEPTH 4") (newline)
  (display "MAXVAL 255") (newline)
  (display "TUPLTYPE RGB_ALPHA") (newline)
  (display "ENDHDR") (newline)
  (loop 0 0))

;;;-------------------------------------------------------------------

(define (ipart x) (exact (floor x)))
(define (iround x) (ipart (+ x 0.5)))
(define (fpart x) (- x (floor x)))
(define (rfpart x) (- 1.0 (fpart x)))

(define (plot s x y opacity)
  ;; One might prefer a more sophisticated function than mere
  ;; addition. Here, however, the function is addition.
  (let ((combined-opacity (+ opacity (drawing-surface-ref s x y))))
    (drawing-surface-set! s x y (min combined-opacity 1.0))))

(define (drawln% s x0 y0 x1 y1 steep)
  (let* ((dx (- x1 x0))
         (dy (- y1 y0))
         (gradient (if (zero? dx) 1.0 (/ dy dx)))

         ;; Handle the first endpoint.
         (xend (iround x0))
         (yend (+ y0 (* gradient (- xend x0))))
         (xgap (rfpart (+ x0 0.5)))
         (xpxl1 xend)
         (ypxl1 (ipart yend))
         (_ (if steep
                (begin
                  (plot s ypxl1 xpxl1 (* (rfpart yend) xgap))
                  (plot s (+ ypxl1 1) xpxl1 (* (fpart yend) xgap)))
                (begin
                  (plot s xpxl1 ypxl1 (* (rfpart yend) xgap))
                  (plot s xpxl1 (+ ypxl1 1) (* (fpart yend) xgap)))))

         ;; The first y-intersection.
         (intery (+ yend gradient))

         ;; Handle the second endpoint.
         (xend (iround x1))
         (yend (+ y1 (* gradient (- xend x1))))
         (xgap (fpart (+ x1 0.5)))
         (xpxl2 xend)
         (ypxl2 (ipart yend))
         (_ (if steep
                (begin
                  (plot s ypxl2 xpxl2 (* (rfpart yend) xgap))
                  (plot s (+ ypxl2 1) xpxl2 (* (fpart yend) xgap)))
                (begin
                  (plot s xpxl2 ypxl2 (* (rfpart yend) xgap))
                  (plot s xpxl2 (+ ypxl2 1) (* (fpart yend) xgap))))))

    ;; Loop over the rest of the points.
    (if steep
        (do ((x (+ xpxl1 1) (+ x 1))
             (intery intery (+ intery gradient)))
            ((= x xpxl2))
          (plot s (ipart intery) x (rfpart intery))
          (plot s (+ (ipart intery) 1) x (fpart intery)))
        (do ((x (+ xpxl1 1) (+ x 1))
             (intery intery (+ intery gradient)))
            ((= x xpxl2))
          (plot s x (ipart intery) (rfpart intery))
          (plot s x (+ (ipart intery) 1) (fpart intery))))))

(define (draw-line s x0 y0 x1 y1)
  (let ((xdiff (abs (- x1 x0)))
        (ydiff (abs (- y1 y0))))
    (if (<= ydiff xdiff)
        (if (<= x0 x1)
            ;; R7RS lets you say #false and #true, as equivalents of
            ;; #f and #t. (To support such things as #false and #true,
            ;; the "r7rs" egg for CHICKEN Scheme 5 comes with a
            ;; special reader.)
            (drawln% s x0 y0 x1 y1 #false)
            (drawln% s x1 y1 x0 y0 #false))
        (if (<= y0 y1)
            (drawln% s y0 x0 y1 x1 #true)
            (drawln% s y1 x1 y0 x0 #true)))))

;;;-------------------------------------------------------------------

(define u0 0)
(define v0 0)
(define u1 999)
(define v1 749)

(define PI (* 4.0 (atan 1.0)))
(define PI/180 (/ PI 180.0))

(define (cosdeg theta) (cos (* theta PI/180)))
(define (sindeg theta) (sin (* theta PI/180)))

(define s (make-drawing-surface u0 v0 u1 v1))

;; The values of theta are exactly representable in either binary or
;; decimal floating point, and therefore the following loop will NOT
;; do the angle zero twice. (If you might stray from exact
;; representations, you must do something different, such as increment
;; an integer.)
(let ((x0 (inexact (* (/ 380 640) u1)))
      (y0 (inexact (* (/ 130 480) v1))))
  (do ((theta 0.0 (+ theta 5.0)))
      ((<= 360.0 theta))
    (let ((cos-theta (cosdeg theta))
          (sin-theta (sindeg theta)))
      (let ((x1 (+ x0 (* cos-theta 1200.0)))
            (y1 (+ y0 (* sin-theta 1200.0))))
        (draw-line s x0 y0 x1 y1)))))

(define args (command-line))
(unless (= (length args) 2)
  (parameterize ((current-output-port (current-error-port)))
    (display (string-append "Usage: " (car args) " FILENAME"))
    (newline)
    (display (string-append "       " (car args) " -"))
    (newline) (newline)
    (display (string-append "The second form writes the PAM file"
                            " to standard output."))
    (newline)
    (exit 1)))
(if (string=? (cadr args) "-")
    (write-PAM s violet9)
    (with-output-to-file (list-ref args 1)
      (lambda () (write-PAM s violet9))))

;;;-------------------------------------------------------------------
