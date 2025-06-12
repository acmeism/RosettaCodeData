(defun make-colors ()
  "Make a list of colors in RGB format."
  (let ((red #xff)
      (green #x0)
      (blue #x0)
      (colors))
  (while (<= green #xff)
    (push (format "#%02x%02x%02x" red green blue) colors)
    (setq green (+ green #x11)))
  (setq green #xff)
  (while (>= red #x0)
    (push (format "#%02x%02x%02x" red green blue) colors)
    (setq red (- red #x11)))
  (setq red #x0)
  (while (<= blue #xff)
    (push (format "#%02x%02x%02x" red green blue) colors)
    (setq blue (+ blue #x11)))
  (setq blue #xff)
  (while (>= green #x0)
    (push (format "#%02x%02x%02x" red green blue) colors)
    (setq green (- green #x11)))
  (setq green #x0)
  (while (<= red #xff)
    (push (format "#%02x%02x%02x" red green blue) colors)
    (setq red (+ red #x11)))
  (reverse colors)))

(defun sample-colors (sample-size colors)
  "Get SAMPLE-SIZE number from COLORS"
  (let* ((total-colors (length colors))
         (interval (/ (float (- total-colors 1)) (float (- sample-size 1))))
         (color-position-in-list 0)
         (samples))
    (while (< color-position-in-list total-colors)
      (push (nth (round color-position-in-list) colors) samples)
      (setq color-position-in-list (+ interval color-position-in-list)))
    samples))

(defun correct-y (reversed-y)
  "Correct REVERSED-Y to work with Cartesian coordinates.
This function assumes that the y-axis size of the svg-create command
is 400. If it has another value, then the 400 below would need to be
changed. This function is necessary because svg has y axis values
increasing in a downward direction, the opposite of Cartesian
coordinates."
  (- 400 reversed-y))

(defun plot-triangle (svg h k r angle1 angle2 fill-color)
  "Create svg code for triangle inscribed in circle.
Circle center and one point of the triangle is located at point H and
K. Other two points of the triangle are on the circle
circumference. Radius of circle is R. ANGLE is angle in radians of point
on circle relative to the circle center."
  (let ((x1)
        (y1)
        (x2)
        (y2))
    (setq x1 (+ (* r (cos angle1)) h))
    (setq y1 (+ (* r (sin angle1)) k))
    (setq y1 (correct-y y1))
    (setq x2 (+ (* r (cos angle2)) h))
    (setq y2 (+ (* r (sin angle2)) k))
    (setq y2 (correct-y y2))
    (svg-polygon svg (list (cons x1 y1) (cons x2 y2) (cons h  k)) :fill-color fill-color)))

(defun color-wheel (number-of-colors)
  "Create a color-wheel with NUMBER-OF-COLORS."
  (let ((angle 0)
        (portion-of-circle (/ (* 2 float-pi) number-of-colors))
        (colors (sample-colors number-of-colors (make-colors)))
        (svg (svg-create 400 400 :stroke-width 0 :stroke-color "red")))
    (dolist (color colors)
      (plot-triangle svg 200 200 200 angle (+ angle portion-of-circle) color)
      (setq angle (+ angle portion-of-circle)))
    (insert-image (svg-image svg))))
