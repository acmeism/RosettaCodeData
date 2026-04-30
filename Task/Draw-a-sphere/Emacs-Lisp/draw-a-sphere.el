; Draw a sphere

(defun normalize (v)
  "Normalize a vector."
  (setq invlen (/ 1.0 (sqrt (dot v v))))
  (mapcar (lambda (x) (* invlen x)) v))

(defun dot (v1 v2)
  "Dot product of two vectors."
  (+ (* (car v1) (car v2))
     (* (cadr v1) (cadr v2))
     (* (caddr v1) (caddr v2))))

(defun make-array (size)
  "Create an empty array with size*size elements."
  (setq m-array (make-vector size nil))
  (dotimes (i size)
    (setf (aref m-array i) (make-vector size 0)))
  m-array)

(defun pic-lines (arr size)
  "Turn array into a string."
  (setq all "")
  (dotimes (y size)
    (setq line "")
    (dotimes (x size)
      (setq line (concat line (format "%i \n" (elt (elt arr y) x)))))
    (setq all (concat all line "\n")))
  all)

(defun pic-show (arr size)
  "Convert size*size array to grayscale PBM image and show it."
  (insert-image (create-image (concat (format "P2
%i %i 255\n" size size) (pic-lines arr size)) 'pbm t)))

(defun sphere (size k amb dir)
  "Draw a sphere."
  (let ((arr (make-array size))
        (ndir (normalize dir))
        (r (/ size 2)))
    (dotimes (yp size)
      (dotimes (xp size)
        (setq x (- xp r))
        (setq y (- yp r))
        (setq z (- (* r r) (* x x) (* y y)))
        (if (>= z 0)
          (let* ((vec (normalize (list x y (sqrt z))))
                 (s (max 0 (dot vec ndir)))
                 (lum (max 0 (min 255 (* 255 (+ amb (expt s k))
                                                    (/ (1+ amb)))))))
            (setf (elt (elt arr yp) xp) lum)))))
    (pic-show arr size)))

(sphere 200 1.5 0.2 '(-30 -30 50))
