; === Graphical Mandelbrot ============================================

(setq mandel-size (cons 320 300))
(setq xmin -2)
(setq xmax .5)
(setq ymin -1.2)
(setq ymax 1.2)
(setq max-iter 20)

(defun mandel-iter-point (x y)
  "Run the actual iteration for each point."
  (let ((xp 0)
        (yp 0)
        (it 0)
        (xt 0))
    (while (and (< (+ (* xp xp) (* yp yp)) 4) (< it max-iter))
      (setq xt (+ (* xp xp) (* -1 yp yp) x))
      (setq yp (+ (* 2 xp yp) y))
      (setq xp xt)
      (setq it (1+ it)))
    it))

(defun mandel-iter (p)
  "Return string for point based on whether inside/outside the set."
  (let ((it (mandel-iter-point (car p) (cdr p))))
    (if (= it max-iter) "*" (if (cl-oddp it) "+" "-"))))

(defun mandel-pos (x y)
  "Convert screen coordinates to input coordinates."
  (let ((xp (+ xmin (* (- xmax xmin) (/ (float x) (car mandel-size)))))
        (yp (+ ymin (* (- ymax ymin) (/ (float y) (cdr mandel-size))))))
       (cons xp yp)))

(defun string-to-image (str)
  "Convert image data string to XPM image."
  (create-image (concat (format "/* XPM */
static char * mandel[] = {
\"%i %i 3 1\",
\"+      c #ff0000\",
\"-      c #0000ff\",
\"*      c #000000\"," (car mandel-size) (cdr mandel-size))
    str "};") 'xpm t))

(defun mandel-pic ()
  "Plot the Mandelbrot set."
  (setq all "")
  (dotimes (y (cdr mandel-size))
    (setq line "")
    (dotimes (x (car mandel-size))
      (setq line (concat line (mandel-iter (mandel-pos x y)))))
    (setq all (concat all "\"" line "\",\n")))
  (insert-image (string-to-image all)))

(mandel-pic)
