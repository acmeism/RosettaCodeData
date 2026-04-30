; Barnsley fern

(defun make-array (size)
  "Create an empty array with size*size elements."
  (setq m-array (make-vector size nil))
  (dotimes (i size)
    (setf (aref m-array i) (make-vector size 0)))
  m-array)

(defun barnsley-next (p)
  "Return the next Barnsley fern coordinates."
  (let ((r (random 100))
        (x (car p))
        (y (cdr p)))
      (cond ((< r 2)  (setq nx 0) (setq ny (* 0.16 y)))
            ((< r 9)  (setq nx (- (* 0.2 x) (* 0.26 y)))
                        (setq ny (+ 1.6 (* 0.23 x) (* 0.22 y))))
            ((< r 16) (setq nx (+ (* -0.15 x) (* 0.28 y)))
                        (setq ny (+ 0.44 (* 0.26 x) (* 0.24 y))))
            (t        (setq nx (+ (* 0.85 x) (* 0.04 y)))
                        (setq ny (+ 1.6 (* -0.04 x) (* 0.85 y)))))
      (cons nx ny)))

(defun barnsley-lines (arr size)
  "Turn array into a string for XPM conversion."
  (setq all "")
  (dotimes (y size)
    (setq line "")
    (dotimes (x size)
      (setq line (concat line (if (= (elt (elt arr y) x) 1) "*" "."))))
    (setq all (concat all "\"" line "\",\n")))
  all)

(defun barnsley-show (arr size)
  "Convert size*size array to XPM image and show it."
  (insert-image (create-image (concat (format "/* XPM */
static char * barnsley[] = {
\"%i %i 2 1\",
\".      c #000000\",
\"*      c #00ff00\"," size size)
    (barnsley-lines arr size) "};") 'xpm t)))

(defun barnsley (size scale max-iter)
  "Plot the Barnsley fern."
  (let ((arr (make-array size))
        (p (cons 0 0)))
    (dotimes (it max-iter)
      (setq p (barnsley-next p))
      (setq x (round (+ (/ size 2) (* scale (car p)))))
      (setq y (round (- size (* scale (cdr p)) 1)))
      (setf (elt (elt arr y) x) 1))
    (barnsley-show arr size)))

(barnsley 400 35 100000)
