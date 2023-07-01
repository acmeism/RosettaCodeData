; === Graphical Julia set display in Emacs =====================

(setq julia-size (cons 300 200))
(setq xmin -1.5)
(setq xmax 1.5)
(setq ymin -1)
(setq ymax 1)
(setq julia0 (cons -0.512511498387847167 0.521295573094847167))
(setq max-iter 100)

(defun julia-iter-point (x y)
  "Run the actual iteration for each point."
  (let ((xp x)
        (yp y)
        (it 0)
        (xt 0))
    (while (and (< (+ (* xp xp) (* yp yp)) 4) (< it max-iter))
      (setq xt (+ (* xp xp) (* -1 yp yp) (car julia0)))
      (setq yp (+ (* 2 xp yp) (cdr julia0)))
      (setq xp xt)
      (setq it (1+ it)))
    it))

(defun julia-iter (p)
  "Return string for point based on whether inside/outside the set."
  (let ((it (julia-iter-point (car p) (cdr p))))
    (if (= it max-iter) "*" (if (cl-oddp it) "+" "-"))))

(defun julia-pos (x y)
  "Convert screen coordinates to input coordinates."
  (let ((xp (+ xmin (* (- xmax xmin) (/ (float x) (car julia-size)))))
        (yp (+ ymin (* (- ymax ymin) (/ (float y) (cdr julia-size))))))
       (cons xp yp)))

(defun string-to-image (str)
  "Convert image data string to XPM image with three colors."
  (create-image (concat (format "/* XPM */
static char * julia[] = {
\"%i %i 3 1\",
\"+      c #ff0000\",
\"-      c #0000ff\",
\"*      c #000000\"," (car julia-size) (cdr julia-size))
    str "};") 'xpm t))

(defun julia-pic ()
  "Plot the Julia set in color."
  (setq all "")
  (dotimes (y (cdr julia-size))
    (setq line "")
    (dotimes (x (car julia-size))
      (setq line (concat line (julia-iter (julia-pos x y)))))
    (setq all (concat all "\"" line "\",\n")))
  (insert-image (string-to-image all)))

(julia-pic)
