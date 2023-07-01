;; (require :lispbuilder-sdl)

(defun draw-noise (surface)
  "draws noise on the surface. Returns the surface"
  (let ((width (sdl:width surface))
	(height (sdl:height surface))
	(i-white (sdl:map-color sdl:*white* surface))
	(i-black (sdl:map-color sdl:*black* surface)))
    (sdl-base::with-pixel (s (sdl:fp surface))
      (dotimes (h height)
	(dotimes (w width)
	  (sdl-base::write-pixel s w h (if (zerop (random 2))
					   i-white i-black ))))))
  surface)

(defun draw-fps (surface)
  "draws fps text-info on surface. Returns surface"
  (sdl:with-surface (s surface)
    (sdl:draw-string-solid-* (format nil "FPS: ~,3f" (sdl:average-fps))
			     20 20 :surface s :color sdl:*magenta*)))

(defun main ()
  "main function, initializes the library and creates de display window"
  (setf *random-state* (make-random-state))
  (sdl:with-init (SDL:SDL-INIT-VIDEO SDL:SDL-INIT-TIMER)
    (let ((main-window (sdl:window 320 240
				   :title-caption "noise_sdl.lisp"
				   :bpp 8
				   :flags (logior SDL:SDL-DOUBLEBUF SDL:SDL-HW-SURFACE)
				   :fps (make-instance 'sdl:fps-unlocked))))
      (sdl:initialise-default-font)
      (sdl:with-events ()
	(:idle ()
	       (sdl:update-display (draw-fps (draw-noise main-window))))
	(:video-expose-event ()
			     (sdl:update-display))
	(:quit-event () T)))))

(main)
