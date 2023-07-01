(require :lispbuilder-sdl)
(require :simple-rgb)

(defparameter *palette*
  (let ((palette-aux (make-array 256 :element-type 'fixnum)))
    (dotimes (i 256)
      (let ((color_i (simple-rgb:hsv->rgb (simple-rgb:hsv (/ i 255.0) 1.0 1.0))))
        (setf (aref palette-aux i) (loop :for component :across color_i
                                       :for i :from 0
                                       :sum (ash component (* 8 i))))))
    palette-aux)
  "palette")

(defun value->color (palette palette-shift index)
  (aref palette (mod (+ index palette-shift) (length palette))))

(defun return-color-by-pos (x y &optional w h)
  "returns a color index"
  (floor
   (/ (+ (+ 128.0 (* 128.0 (sin (/ x 16.0))))
         (+ 128.0 (* 128.0 (sin (/ y 8.0))))
         (+ 128.0 (* 128.0 (sin (/ (+ x y) 16.0))))
         (+ 128.0 (* 128.0 (sin (/ (sqrt (+ (* x x) (* y y))) 8.0)))))
      4.0)))

(defun return-color-by-pos-another (x y &optional w h)
  "a different function that returns a color index"
  (floor
   (/ (+ (+ 128.0 (* 128.0 (sin (/ x 16.0))))
         (+ 128.0 (* 128.0 (sin (/ y 32.0))))
         (+ 128.0 (* 128.0 (sin (/ (sqrt (+ (expt (/ (- x w) 2.0) 2) (expt (/ (- y h) 2.0) 2))) 8.0))))
         (+ 128.0 (* 128.0 (sin (/ (sqrt (+ (* x x) (* y y))) 8.0)))))
      4.0)))

(defun plasma-render (surface palette-shift)
  "render plasma"
  (let ((width (sdl:width surface))
        (height (sdl:height surface)))
    (sdl-base::with-pixel (s (sdl:fp surface))
      (dotimes (h height)
        (dotimes (w width)
          (sdl-base::write-pixel s w h (value->color *palette* palette-shift (funcall #'return-color-by-pos-another w h width height)))))))
  surface)

(defun demo/plasma ()
  "main function: shows a window rendering a plasma efect"
  (sdl:with-init ()
    (let ((win (sdl:window 320 240
                           :bpp 24
                           :resizable nil
                           :title-caption "demo/plasma"
                           :icon-caption "demo/plasma")))
      (let ((palette-shift 0))
      (sdl:update-display win)
      (sdl:with-events ()
        (:idle
         (plasma-render win palette-shift)
         (sdl:update-display win)
         (incf palette-shift))
        (:video-expose-event () (sdl:update-display win))
        (:key-down-event (:key key)
                         (when (or
                                (sdl:key= key :sdl-key-escape)
                                (sdl:key= key :sdl-key-q))
                           (sdl:push-quit-event)))
        (:quit-event () t))))))

(demo/plasma)
