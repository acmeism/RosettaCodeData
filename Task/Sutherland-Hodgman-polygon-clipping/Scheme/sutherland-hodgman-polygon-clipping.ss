;;; Sutherland-Hodgman polygon clipping.

(define (evaluate-line x1 y1 x2 y2 x)
  ;; Given the straight line between (x1,y1) and (x2,y2), evaluate it
  ;; at x.
  (let ((dy (- y2 y1))
        (dx (- x2 x1)))
    (let ((slope (/ dy dx))
          (intercept (/ (- (* dx y1) (* dy x1)) dx)))
      (+ (* slope x) intercept))))

(define (intersection-of-lines x1 y1 x2 y2 x3 y3 x4 y4)
  ;; Given the line between (x1,y1) and (x2,y2), and the line between
  ;; (x3,y3) and (x4,y4), find their intersection.
  (cond ((= x1 x2) (list x1 (evaluate-line x3 y3 x4 y4 x1)))
        ((= x3 x4) (list x3 (evaluate-line x1 y1 x2 y2 x3)))
        (else (let ((denominator (- (* (- x1 x2) (- y3 y4))
                                    (* (- y1 y2) (- x3 x4))))
                    (x1*y2-y1*x2 (- (* x1 y2) (* y1 x2)))
                    (x3*y4-y3*x4 (- (* x3 y4) (* y3 x4))))
                (let ((xnumerator (- (* x1*y2-y1*x2 (- x3 x4))
                                     (* (- x1 x2) x3*y4-y3*x4)))
                      (ynumerator (- (* x1*y2-y1*x2 (- y3 y4))
                                     (* (- y1 y2) x3*y4-y3*x4))))
                  (list (/ xnumerator denominator)
                        (/ ynumerator denominator)))))))

(define (intersection-of-edges e1 e2)
  ;;
  ;; A point is a list of two coordinates, and an edge is a list of
  ;; two points.
  ;;
  ;; I am not using any SRFI-9 records, or the like, that define
  ;; actual new types, although I would do so if writing a more
  ;; serious implementation. Also, I am not using any pattern matcher.
  ;; A pattern matcher would make this code less tedious with
  ;; "cadaddaddr" notations.
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

(define (point-is-left-of-edge? pt edge)
  (let ((x (car pt))
        (y (cadr pt))
        (x1 (caar edge))
        (y1 (cadar edge))
        (x2 (caadr edge))
        (y2 (cadadr edge)))
    ;; Outer product of the vectors (x1,y1)-->(x,y) and
    ;; (x1,y1)-->(x2,y2)
    (negative? (- (* (- x x1) (- y2 y1))
                  (* (- x2 x1) (- y y1))))))

(define (clip-subject-edge subject-edge clip-edge accum)
  (define left-of? point-is-left-of-edge?)
  (define (intersection)
    (intersection-of-edges subject-edge clip-edge))
  (let ((s1 (car subject-edge))
        (s2 (cadr subject-edge)))
    (let ((s2-is-inside? (left-of? s2 clip-edge))
          (s1-is-inside? (left-of? s1 clip-edge)))
      (if s2-is-inside?
          (if s1-is-inside?
              (cons s2 accum)
              (cons s2 (cons (intersection) accum)))
          (if s1-is-inside?
              (cons (intersection) accum)
              accum)))))

(define (for-each-subject-edge i subject-points clip-edge accum)
  (define n (vector-length subject-points))
  (if (= i n)
      (list->vector (reverse accum))
      (let ((s2 (vector-ref subject-points i))
            (s1 (vector-ref subject-points
                            (- (if (zero? i) n i) 1))))
        (let ((accum (clip-subject-edge (list s1 s2)
                                        clip-edge accum)))
          (for-each-subject-edge (+ i 1) subject-points
                                 clip-edge accum)))))

(define (for-each-clip-edge i subject-points clip-points)
  (define n (vector-length clip-points))
  (if (= i n)
      subject-points
      (let ((c2 (vector-ref clip-points i))
            (c1 (vector-ref clip-points (- (if (zero? i) n i) 1))))
        (let ((subject-points
               (for-each-subject-edge 0 subject-points
                                      (list c1 c2) '())))
          (for-each-clip-edge (+ i 1) subject-points clip-points)))))

(define (clip subject-points clip-points)
  (for-each-clip-edge 0 subject-points clip-points))

(define (write-eps subject-points clip-points result-points)

  ;; I use only some of the most basic output procedures. Schemes tend
  ;; to include more advanced means to write output, often resembling
  ;; those of Common Lisp.

  (define (x pt) (exact->inexact (car pt)))
  (define (y pt) (exact->inexact (cadr pt)))

  (define (moveto pt)
    (display (x pt))
    (display " ")
    (display (y pt))
    (display " moveto")
    (newline))

  (define (lineto pt)
    (display (x pt))
    (display " ")
    (display (y pt))
    (display " lineto")
    (newline))

  (define (setrgbcolor rgb)
    (display rgb)
    (display " setrgbcolor")
    (newline))

  (define (simple-word word)
    (lambda ()
      (display word)
      (newline)))

  (define closepath (simple-word "closepath"))
  (define fill (simple-word "fill"))
  (define stroke (simple-word "stroke"))
  (define gsave (simple-word "gsave"))
  (define grestore (simple-word "grestore"))

  (define (showpoly poly line-color fill-color)
    (define n (vector-length poly))
    (moveto (vector-ref poly 0))
    (do ((i 1 (+ i 1)))
        ((= i n))
      (lineto (vector-ref poly i)))
    (closepath)
    (setrgbcolor line-color)
    (gsave)
    (setrgbcolor fill-color)
    (fill)
    (grestore)
    (stroke))

  (define (code s)
    (display s)
    (newline))

  (code "%!PS-Adobe-3.0 EPSF-3.0")
  (code "%%BoundingBox: 40 40 360 360")
  (code "0 setlinewidth")
  (showpoly clip-points ".5 0 0" "1 .7 .7")
  (showpoly subject-points "0 .2 .5" ".4 .7 1")
  (code "2 setlinewidth")
  (code "[10 8] 0 setdash")
  (showpoly result-points ".5 0 .5" ".7 .3 .8")
  (code "%%EOF"))

(define (write-eps-to-file outfile subject-points clip-points
                           result-points)
  (with-output-to-file outfile
    (lambda ()
      (write-eps subject-points clip-points result-points))))

(define subject-points
  #((50 150)
    (200 50)
    (350 150)
    (350 300)
    (250 300)
    (200 250)
    (150 350)
    (100 250)
    (100 200)))

(define clip-points
  #((100 100)
    (300 100)
    (300 300)
    (100 300)))

(define result-points (clip subject-points clip-points))

(display result-points)
(newline)
(write-eps-to-file "sutherland-hodgman.eps"
                   subject-points clip-points result-points)
(display "Wrote sutherland-hodgman.eps")
(newline)
