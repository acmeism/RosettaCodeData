;;; The program outputs a transparency mask in plain Portable Gray Map
;;; format.
;;; -------------------------------------------------------------------

(defstruct (drawing-surface
            (:constructor make-drawing-surface (u0 v0 u1 v1)))
  (u0 0 :type fixnum :read-only t)
  (v0 0 :type fixnum :read-only t)
  (u1 0 :type fixnum :read-only t)
  (v1 0 :type fixnum :read-only t)
  (pixels (make-array (* (- u1 u0 -1) (- v1 v0 -1))
                      :element-type 'single-float
                      :initial-element 0.0)))

;;; In calls to drawing-surface-ref and drawing-surface-set, indices
;;; outside the drawing_surface are allowed. Such indices are treated
;;; as if you were trying to draw on the air.

(defun drawing-surface-ref (s x y)
  (let ((u0 (drawing-surface-u0 s))
        (v0 (drawing-surface-v0 s))
        (u1 (drawing-surface-u1 s))
        (v1 (drawing-surface-v1 s)))
    (if (and (<= u0 x) (<= x u1) (<= v0 y) (<= y v1))
        (aref (drawing-surface-pixels s)
              (+ (- x u0) (* (- v1 y) (- u1 u0 -1))))
        0.0))) ;; The Scheme for this returns +nan.0

(defun drawing-surface-set (s x y opacity)
  (let ((u0 (drawing-surface-u0 s))
        (v0 (drawing-surface-v0 s))
        (u1 (drawing-surface-u1 s))
        (v1 (drawing-surface-v1 s)))
    (when (and (<= u0 x) (<= x u1) (<= v0 y) (<= y v1))
      (setf (aref (drawing-surface-pixels s)
                  (+ (- x u0) (* (- v1 y) (- u1 u0 -1))))
            opacity))))

(defun write-transparency-mask (s)
  ;; In the Scheme, I had the program write a Portable Arbitrary Map
  ;; with both a color and a transparency map. Here, by contrast, only
  ;; the transparency map will be output. It will be in plain Portable
  ;; Gray Map format, but representing opacities rather than
  ;; whitenesses. (Thus there will be no need for gamma corrections.)
  ;; See the pgm(5) manpage for a discussion of this use of PGM
  ;; format.
  (let* ((u0 (drawing-surface-u0 s))
         (v0 (drawing-surface-v0 s))
         (u1 (drawing-surface-u1 s))
         (v1 (drawing-surface-v1 s))
         (w (- u1 u0 -1))
         (h (- v1 v0 -1))
         (|(w * h) - 1| (1- (* w h)))
         (opacities (drawing-surface-pixels s)))
    ;; "format" is not standard in Scheme, although it is widely
    ;; implemented as an extension. However, in Common Lisp it is
    ;; standardized. So let us use it.
    (format t "P2~%")
    (format t "# transparency map~%")
    (format t "~a ~a~%" w h)
    (format t "255~%")
    (loop for i from 0 to |(w * h) - 1|
          do (let* ((opacity (aref opacities i))
                    (byteval (round (* 255 opacity))))
               ;; Using "plain" PGM format avoids the issue of how to
               ;; write raw bytes. OTOH it makes the output file large
               ;; and slow to work with. (In the R7RS Scheme,
               ;; "bytevectors" provided an obvious way to write
               ;; bytes.)
               (princ byteval)
               (terpri)))))

;;;-------------------------------------------------------------------

(defun ipart (x) (floor x))
(defun iround (x) (ipart (+ x 0.5)))
(defun fpart (x) (nth-value 1 (floor x)))
(defun rfpart (x) (- 1.0 (fpart x)))

(defun plot-shallow (s x y opacity)
  (let ((combined-opacity
          (+ opacity (drawing-surface-ref s x y))))
    (drawing-surface-set s x y (min combined-opacity 1.0))))

(defun plot-steep (s x y opacity)
  (plot-shallow s y x opacity))

(defun drawln% (s x0 y0 x1 y1 plot)
  (let* ((dx (- x1 x0))
         (dy (- y1 y0))
         (gradient (if (zerop dx) 1.0 (/ dy dx)))

         ;; Handle the first endpoint.
         (xend (iround x0))
         (yend (+ y0 (* gradient (- xend x0))))
         (xgap (rfpart (+ x0 0.5)))
         (xpxl1 xend)
         (ypxl1 (ipart yend))
         (_ (funcall plot s xpxl1 ypxl1 (* (rfpart yend) xgap)))
         (_ (funcall plot s xpxl1 (1+ ypxl1) (* (fpart yend) xgap)))

         (first-y-intersection (+ yend gradient))

         ;; Handle the second endpoint.
         (xend (iround x1))
         (yend (+ y1 (* gradient (- xend x1))))
         (xgap (fpart (+ x1 0.5)))
         (xpxl2 xend)
         (ypxl2 (ipart yend))
         (_ (funcall plot s xpxl2 ypxl2 (* (rfpart yend) xgap)))
         (_ (funcall plot s xpxl2 (1+ ypxl2) (* (fpart yend) xgap))))

    ;; Loop over the rest of the points.
    (do ((x (+ xpxl1 1) (1+ x))
         (intery first-y-intersection (+ intery gradient)))
        ((= x xpxl2))
      (funcall plot s x (ipart intery) (rfpart intery))
      (funcall plot s x (1+ (ipart intery)) (fpart intery)))))

(defun draw-line (s x0 y0 x1 y1)
  (let ((x0 (coerce x0 'single-float))
        (y0 (coerce y0 'single-float))
        (x1 (coerce x1 'single-float))
        (y1 (coerce y1 'single-float)))
    (let ((xdiff (abs (- x1 x0)))
          (ydiff (abs (- y1 y0))))
      (if (<= ydiff xdiff)
          (if (<= x0 x1)
              (drawln% s x0 y0 x1 y1 #'plot-shallow)
              (drawln% s x1 y1 x0 y0 #'plot-shallow))
          (if (<= y0 y1)
              (drawln% s y0 x0 y1 x1 #'plot-steep)
              (drawln% s y1 x1 y0 x0 #'plot-steep))))))

;;;-------------------------------------------------------------------
;;; Draw a catenary as the evolute of a tractrix. See
;;; https://en.wikipedia.org/w/index.php?title=Tractrix&oldid=1143719802#Properties
;;; See also https://archive.is/YfgXW

(defvar u0 -399)
(defvar v0 -199)
(defvar u1 400)
(defvar v1 600)

(defvar s (make-drawing-surface u0 v0 u1 v1))


(loop for i from -300 to 300 by 10
      for t_ = (/ i 100.0)          ; Independent parameter.
      for x = (- t_  (tanh t_))     ; Parametric tractrix coordinates.
      for y = (/ (cosh t_))         ;
      for u = y                     ; Parametric normal vector.
      for v = (* y (sinh t_))       ;
      for x0 = (* 100.0 (- x (* 10.0 u))) ; Scaled for plotting.
      for y0 = (* 100.0 (- y (* 10.0 v)))
      for x1 = (* 100.0 (+ x (* 10.0 u)))
      for y1 = (* 100.0 (+ y (* 10.0 v)))
      do (draw-line s x0 y0 x1 y1))

(write-transparency-mask s)

;;;-------------------------------------------------------------------
