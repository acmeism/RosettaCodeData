; Chaos game

(defun make-array (size)
  "Create an empty array with size*size elements."
  (setq m-array (make-vector size nil))
  (dotimes (i size)
    (setf (aref m-array i) (make-vector size 0)))
  m-array)

(defun chaos-next (p)
  "Return the next coordinates."
  (let* ((points (list (cons 1 0) (cons -1 0) (cons 0 (sqrt 3))))
 	 (v (elt points (random 3)))
         (x (car p))
         (y (cdr p))
         (x2 (car v))
         (y2 (cdr v)))
      (setq nx (/ (+ x x2) 2.0))
      (setq ny (/ (+ y y2) 2.0))
      (cons nx ny)))

(defun chaos-lines (arr size)
  "Turn array into a string for XPM conversion."
  (setq all "")
  (dotimes (y size)
    (setq line "")
    (dotimes (x size)
      (setq line (concat line (if (= (elt (elt arr y) x) 1) "*" "."))))
    (setq all (concat all "\"" line "\",\n")))
  all)

(defun chaos-show (arr size)
  "Convert size*size array to XPM image and show it."
  (insert-image (create-image (concat (format "/* XPM */
static char * chaos[] = {
\"%i %i 2 1\",
\".      c #000000\",
\"*      c #00ff00\"," size size)
    (chaos-lines arr size) "};") 'xpm t)))

(defun chaos (size scale max-iter)
  "Play the chaos game."
  (let ((arr (make-array size))
        (p (cons 0 0)))
    (dotimes (it max-iter)
      (setq p (chaos-next p))
      (setq x (round (+ (/ size 2) (* scale (car p)))))
      (setq y (round (+ (- size 10) (* -1 scale (cdr p)))))
      (setf (elt (elt arr y) x) 1))
    (chaos-show arr size)))

(chaos 400 180 50000)
