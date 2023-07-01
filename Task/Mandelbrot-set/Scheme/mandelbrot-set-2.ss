;; A program written for CHICKEN Scheme version 5.3.0 and various
;; eggs.

(import (r7rs))
(import (scheme base))
(import (scheme case-lambda))
(import (scheme inexact))

(import (prefix sdl2 "sdl2:"))
(import (prefix imlib2 "imlib2:"))

(import (format))
(import (matchable))
(import (simple-exceptions))

(define sdl2-subsystems-used '(events video))

;; ------------------------------
;; Basics for using the sdl2 egg:
(sdl2:set-main-ready!)
(sdl2:init! sdl2-subsystems-used)
(on-exit sdl2:quit!)
(current-exception-handler
 (let ((original-handler (current-exception-handler)))
   (lambda (exception)
     (sdl2:quit!)
     (original-handler exception))))
;; ------------------------------

(define-record-type <mandel-params>
  (%%make-mandel-params)
  mandel-params?
  (window ref-window set-window!)
  (xcenter ref-xcenter set-xcenter!)
  (ycenter ref-ycenter set-ycenter!)
  (pixels-per-unit ref-pixels-per-unit set-pixels-per-unit!)
  (pixels-per-event-check ref-pixels-per-event-check
                          set-pixels-per-event-check!)
  (max-escape-time ref-max-escape-time set-max-escape-time!))

(define initial-width                   400)
(define initial-height                  400)
(define initial-xcenter                -3/4)
(define initial-ycenter                 0)
(define initial-pixels-per-unit         150)
(define initial-pixels-per-event-check  1000)
(define initial-max-escape-time         1000)

(define (make-mandel-params window)
  (let ((params (%%make-mandel-params)))
    (set-window! params window)
    (set-xcenter! params initial-xcenter)
    (set-ycenter! params initial-ycenter)
    (set-pixels-per-unit! params initial-pixels-per-unit)
    (set-pixels-per-event-check! params
                                 initial-pixels-per-event-check)
    (set-max-escape-time! params initial-max-escape-time)
    params))

(define window (sdl2:create-window! "mandelbrot set task"
                                    'centered 'centered
                                    initial-width initial-height
                                    '()))
(define params (make-mandel-params window))

(define empty-color (sdl2:make-color 200 200 200))

(define (clear-mandel!)
  (sdl2:fill-rect! (sdl2:window-surface (ref-window params))
                   #f empty-color)
  (sdl2:update-window-surface! window))

(define drawing? #t)
(define redraw? #f)

(define (draw-mandel! event-checker)
  (clear-mandel!)
  (let repeat ()
    (let*-values
        (((window) (ref-window params))
         ((width height) (sdl2:window-size window)))
      (let* ((xcenter (ref-xcenter params))
             (ycenter (ref-ycenter params))
             (pixels-per-unit (ref-pixels-per-unit params))
             (pixels-per-event-check
              (ref-pixels-per-event-check params))
             (max-escape-time (ref-max-escape-time params))
             (step (/ 1.0 pixels-per-unit))
             (xleft (- xcenter (/ width (* 2.0 pixels-per-unit))))
             (ytop (+ ycenter (/ height (* 2.0 pixels-per-unit))))
             (pixel-count 0))
        (do ((j 0 (+ j 1))
             (cy ytop (- cy step)))
            ((= j height))
          (do ((i 0 (+ i 1))
               (cx xleft (+ cx step)))
              ((= i width))
            (let* ((color (compute-color-by-escape-time-algorithm
                           cx cy max-escape-time)))
              (sdl2:surface-set! (sdl2:window-surface window)
                                 i j color)
              (if (= pixel-count pixels-per-event-check)
                  (let ((event-checker (call/cc event-checker)))
                    (cond (redraw?
                           (set! redraw? #f)
                           (clear-mandel!)
                           (repeat)))
                    (set! pixel-count 0))
                  (set! pixel-count (+ pixel-count 1)))))
          ;; Display a row.
          (sdl2:update-window-surface! window))))
    (set! drawing? #f)
    (repeat)))

(define (compute-color-by-escape-time-algorithm
         cx cy max-escape-time)
  (escape-time->color (compute-escape-time cx cy max-escape-time)
                      max-escape-time))

(define (compute-escape-time cx cy max-escape-time)
  (let loop ((x 0.0)
             (y 0.0)
             (iter 0))
    (if (= iter max-escape-time)
        iter
        (let ((xsquared (* x x))
              (ysquared (* y y)))
          (if (< 4 (+ xsquared ysquared))
              iter
              (let ((x (+ cx (- xsquared ysquared)))
                    (y (+ cy (* (+ x x) y))))
                (loop x y (+ iter 1))))))))

(define (escape-time->color escape-time max-escape-time)
  ;; This is a very naive and ad hoc algorithm for choosing colors,
  ;; but hopefully will suffice for the task. With this algorithm, at
  ;; least one can zoom in and see some of the fractal-like structures
  ;; out on the filaments.
  (let* ((initial-ppu initial-pixels-per-unit)
         (ppu (ref-pixels-per-unit params))
         (fraction (* (/ (log escape-time) (log max-escape-time))))
         (fraction (if (= fraction 1.0)
                       fraction
                       (* fraction
                          (/ (log initial-ppu)
                             (log (max initial-ppu (* 0.05 ppu)))))))
         (value (- 255 (min 255 (exact-rounded (* fraction 255))))))
    (sdl2:make-color value value value)))

(define (exact-rounded x)
  (exact (round x)))

(define (event-loop)
  (define event (sdl2:make-event))
  (define painter draw-mandel!)
  (define zoom-ratio 2)

  (define (recenter! xcoord ycoord)
    (let*-values
        (((window) (ref-window params))
         ((width height) (sdl2:window-size window))
         ((ppu) (ref-pixels-per-unit params)))
      (set-xcenter! params
                    (+ (ref-xcenter params)
                       (/ (- (* 2.0 xcoord) width) (* 2.0 ppu))))
      (set-ycenter! params
                    (+ (ref-ycenter params)
                       (/ (- height (* 2.0 ycoord)) (* 2.0 ppu))))))

  (define (zoom-in!)
    (let* ((ppu (ref-pixels-per-unit params))
           (ppu (* ppu zoom-ratio)))
      (set-pixels-per-unit! params ppu)))

  (define (zoom-out!)
    (let* ((ppu (ref-pixels-per-unit params))
           (ppu (* (/ 1.0 zoom-ratio) ppu)))
      (set-pixels-per-unit! params (max 1 ppu))))

  (define (restore-original-settings!)
    (set-xcenter! params initial-xcenter)
    (set-ycenter! params initial-ycenter)
    (set-pixels-per-unit! params initial-pixels-per-unit)
    (set-pixels-per-event-check!
     params initial-pixels-per-event-check)
    (set-max-escape-time! params initial-max-escape-time)
    (set! zoom-ratio 2))

  (define dump-image!            ; Really this should put up a dialog.
    (let ((dump-number 1))
      (lambda ()
        (let*-values
            (((window) (ref-window params))
             ((width height) (sdl2:window-size window))
             ((surface) (sdl2:window-surface window)))
          (let ((filename (string-append "mandelbrot-image-"
                                         (number->string dump-number)
                                         ".png"))
                (img (imlib2:image-create width height)))
            (do ((j 0 (+ j 1)))
                ((= j height))
              (do ((i 0 (+ i 1)))
                  ((= i width))
                (let-values
                    (((r g b a) (sdl2:color->values
                                 (sdl2:surface-ref surface i j))))
                  (imlib2:image-draw-pixel
                   img (imlib2:color/rgba r g b a) i j))))
            (imlib2:image-alpha-set! img #f)
            (imlib2:image-save img filename)
            (format #t "~a written~%" filename)
            (set! dump-number (+ dump-number 1)))))))

  (let loop ()
    (when redraw?
      (set! drawing? #t))
    (when drawing?
      (set! painter (call/cc painter)))
    (set! redraw? #f)
    (if (not (sdl2:poll-event! event))
        (loop)
        (begin
          (match (sdl2:event-type event)
            ('quit)                     ; Quit by leaving the loop.
            ('window
             (match (sdl2:window-event-event event)
               ;; It should be possible to resize the window, but I
               ;; have not yet figured out how to do this with SDL2
               ;; and not crash sometimes.
               ((or 'exposed 'restored)
                (sdl2:update-window-surface! (ref-window params))
                (loop))
               (_ (loop))))
            ('mouse-button-down
             (recenter! (sdl2:mouse-button-event-x event)
                        (sdl2:mouse-button-event-y event))
             (set! redraw? #t)
             (loop))
            ('key-down
             (match (sdl2:keyboard-event-sym event)
               ('q 'quit-by-leaving-the-loop)
               ((or 'plus 'kp-plus)
                (zoom-in!)
                (set! redraw? #t)
                (loop))
               ((or 'minus 'kp-minus)
                (zoom-out!)
                (set! redraw? #t)
                (loop))
               ((or 'n-2 'kp-2)
                (set! zoom-ratio 2)
                (loop))
               ((or 'n-3 'kp-3)
                (set! zoom-ratio 3)
                (loop))
               ((or 'n-4 'kp-4)
                (set! zoom-ratio 4)
                (loop))
               ((or 'n-5 'kp-5)
                (set! zoom-ratio 5)
                (loop))
               ((or 'n-6 'kp-6)
                (set! zoom-ratio 6)
                (loop))
               ((or 'n-7 'kp-7)
                (set! zoom-ratio 7)
                (loop))
               ((or 'n-8 'kp-8)
                (set! zoom-ratio 8)
                (loop))
               ((or 'n-9 'kp-9)
                (set! zoom-ratio 9)
                (loop))
               ('o
                (restore-original-settings!)
                (set! redraw? #t)
                (loop))
               ('p
                (dump-image!)
                (loop))
               (some-key-in-which-we-are-not-interested
                (loop))))
            (some-event-in-which-we-are-not-interested
             (loop)))))))

;; At the least this legend should go in a window, but printing it to
;; the terminal will, hopefully, suffice for the task.
(format #t "~%~8tACTIONS~%")
(format #t "~8t-------~%")
(define fmt "~2t~a~15t: ~a~%")
(format #t fmt "Q key" "quit")
(format #t fmt "mouse button" "recenter")
(format #t fmt "+ key" "zoom in")
(format #t fmt "- key" "zoom in")
(format #t fmt "2 .. 9 key" "set zoom ratio")
(format #t fmt "O key" "restore original")
(format #t fmt "P key" "dump to a PNG")
(format #t "~%")

(event-loop)
