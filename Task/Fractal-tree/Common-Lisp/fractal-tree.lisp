;; (require :lispbuilder-sdl)

(defun deg-to-radian (deg)
  "converts degrees to radians"
  (* deg pi 1/180))

(defun cos-deg (angle)
  "returns cosin of the angle expressed in degress"
  (cos (deg-to-radian angle)))

(defun sin-deg (angle)
  "returns sin of the angle expressed in degress"
  (sin (deg-to-radian angle)))

(defun draw-tree (surface x y angle depth)
  "draws a branch of the tree on the sdl-surface"
  (when (plusp depth)
    (let ((x2 (+ x (round (* depth 10 (cos-deg angle)))))
	  (y2 (+ y (round (* depth 10 (sin-deg angle))))))
      (sdl:draw-line-* x y x2 y2 :surface surface :color sdl:*green*)
      (draw-tree surface x2 y2 (- angle 20) (1- depth))
      (draw-tree surface x2 y2 (+ angle 20) (1- depth)))))

(defun fractal-tree (depth)
  "shows a window with a fractal tree"
  (sdl:with-init ()
    (sdl:window 800 600 :title-caption "fractal-tree")
    (sdl:clear-display sdl:*black*)
    (draw-tree sdl:*default-surface* 400 500 -90 depth)
    (sdl:update-display)
    (sdl:with-events ()
      (:video-expose-event ()
			   (sdl:update-display))
      (:quit-event ()
		   t))))

(fractal-tree 9)
