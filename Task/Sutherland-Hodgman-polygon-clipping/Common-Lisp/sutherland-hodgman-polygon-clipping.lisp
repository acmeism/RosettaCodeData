;;; Sutherland-Hodgman polygon clipping.

(defun evaluate-line (x1 y1 x2 y2 x)
  ;; Given the straight line between (x1,y1) and (x2,y2), evaluate it
  ;; at x.
  (let ((dy (- y2 y1))
        (dx (- x2 x1)))
    (let ((slope (/ dy dx))
          (intercept (/ (- (* dx y1) (* dy x1)) dx)))
      (+ (* slope x) intercept))))

(defun intersection-of-lines (x1 y1 x2 y2 x3 y3 x4 y4)
  ;; Given the line between (x1,y1) and (x2,y2), and the line between
  ;; (x3,y3) and (x4,y4), find their intersection.
  (cond ((= x1 x2) (list x1 (evaluate-line x3 y3 x4 y4 x1)))
        ((= x3 x4) (list x3 (evaluate-line x1 y1 x2 y2 x3)))
        (t (let ((denominator (- (* (- x1 x2) (- y3 y4))
                                 (* (- y1 y2) (- x3 x4))))
                 (x1*y2-y1*x2 (- (* x1 y2) (* y1 x2)))
                 (x3*y4-y3*x4 (- (* x3 y4) (* y3 x4))))
             (let ((xnumerator (- (* x1*y2-y1*x2 (- x3 x4))
                                  (* (- x1 x2) x3*y4-y3*x4)))
                   (ynumerator (- (* x1*y2-y1*x2 (- y3 y4))
                                  (* (- y1 y2) x3*y4-y3*x4))))
               (list (/ xnumerator denominator)
                     (/ ynumerator denominator)))))))

(defun intersection-of-edges (e1 e2)
  ;;
  ;; A point is a list of two coordinates, and an edge is a list of
  ;; two points.
  ;;
  (let ((point1 (car e1))
        (point2 (cadr e1))
        (point3 (car e2))
        (point4 (cadr e2)))
    (let ((x1 (car point1))
          (y1 (cadr point1))
          (x2 (car point2))
          (y2 (cadr point2))
          (x3 (car point3))
          (y3 (cadr point3))
          (x4 (car point4))
          (y4 (cadr point4)))
      (intersection-of-lines x1 y1 x2 y2 x3 y3 x4 y4))))

(defun point-is-left-of-edge-p (pt edge)
  (let ((x (car pt))
        (y (cadr pt))
        (x1 (caar edge))
        (y1 (cadar edge))
        (x2 (caadr edge))
        (y2 (cadadr edge)))
    ;; Outer product of the vectors (x1,y1)-->(x,y) and
    ;; (x1,y1)-->(x2,y2)
    (< (- (* (- x x1) (- y2 y1))
          (* (- x2 x1) (- y y1)))
       0)))

(defun clip-subject-edge (subject-edge clip-edge accum)
  (flet ((intersect ()
           (intersection-of-edges subject-edge clip-edge)))
    (let ((s1 (car subject-edge))
          (s2 (cadr subject-edge)))
      (let ((s2-is-inside (point-is-left-of-edge-p s2 clip-edge))
            (s1-is-inside (point-is-left-of-edge-p s1 clip-edge)))
        (if s2-is-inside
            (if s1-is-inside
                (cons s2 accum)
                (cons s2 (cons (intersect) accum)))
            (if s1-is-inside
                (cons (intersect) accum)
                accum))))))

(defun for-each-subject-edge (i subject-points clip-edge accum)
  (let ((n (length subject-points))
        (accum '()))
    (loop for i from 0 to (1- n)
          do (let ((s2 (aref subject-points i))
                   (s1 (aref subject-points
                             (- (if (zerop i) n i) 1))))
               (setf accum (clip-subject-edge (list s1 s2)
                                              clip-edge accum))))
    (coerce (reverse accum) 'vector)))

(defun for-each-clip-edge (i subject-points clip-points)
  (let ((n (length clip-points)))
    (loop for i from 0 to (1- n)
          do (let ((c2 (aref clip-points i))
                   (c1 (aref clip-points (- (if (zerop i) n i) 1))))
               (setf subject-points
                     (for-each-subject-edge 0 subject-points
                                            (list c1 c2) '()))))
    subject-points))

(defun clip (subject-points clip-points)
  (for-each-clip-edge 0 subject-points clip-points))

(defun write-eps (outf subject-points clip-points result-points)
  (flet ((x (pt) (coerce (car pt) 'float))
         (y (pt) (coerce (cadr pt) 'float))
         (code (s)
           (princ s outf)
           (terpri outf)))
    (flet ((moveto (pt)
             (princ (x pt) outf)
             (princ " " outf)
             (princ (y pt) outf)
             (princ " moveto" outf)
             (terpri outf))
           (lineto (pt)
             (princ (x pt) outf)
             (princ " " outf)
             (princ (y pt) outf)
             (princ " lineto" outf)
             (terpri outf))
           (setrgbcolor (rgb)
             (princ rgb outf)
             (princ " setrgbcolor" outf)
             (terpri outf))
           (closepath () (code "closepath"))
           (fill-it () (code "fill"))
           (stroke () (code "stroke"))
           (gsave () (code "gsave"))
           (grestore () (code "grestore")))
      (flet ((showpoly (poly line-color fill-color)
               (let ((n (length poly)))
                 (moveto (aref poly 0))
                 (loop for i from 1 to (1- n)
                       do (lineto (aref poly i)))
                 (closepath)
                 (setrgbcolor line-color)
                 (gsave)
                 (setrgbcolor fill-color)
                 (fill-it)
                 (grestore)
                 (stroke))))

        (code "%!PS-Adobe-3.0 EPSF-3.0")
        (code "%%BoundingBox: 40 40 360 360")
        (code "0 setlinewidth")
        (showpoly clip-points ".5 0 0" "1 .7 .7")
        (showpoly subject-points "0 .2 .5" ".4 .7 1")
        (code "2 setlinewidth")
        (code "[10 8] 0 setdash")
        (showpoly result-points ".5 0 .5" ".7 .3 .8")
        (code "%%EOF")))))

(defun write-eps-to-file (outfile subject-points clip-points
                          result-points)
  (with-open-file (outf outfile :direction :output
                                :if-exists :supersede
                                :if-does-not-exist :create)
    (write-eps outf subject-points clip-points result-points)))

(defvar subject-points
  #((50 150)
    (200 50)
    (350 150)
    (350 300)
    (250 300)
    (200 250)
    (150 350)
    (100 250)
    (100 200)))

(defvar clip-points
  #((100 100)
    (300 100)
    (300 300)
    (100 300)))

(defvar result-points (clip subject-points clip-points))

(princ result-points)
(terpri)
(write-eps-to-file "sutherland-hodgman.eps"
                   subject-points clip-points result-points)
(princ "Wrote sutherland-hodgman.eps")
(terpri)
