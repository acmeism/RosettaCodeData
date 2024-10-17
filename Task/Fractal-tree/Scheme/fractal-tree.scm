(import (scheme base)
        (scheme file)
        (scheme inexact)
        (scheme write))

(define *scale* 10) ; controls overall size of tree
(define *split* 20) ; controls angle of split (in degrees)

;; construct lines for tree as list of 5-tuples (x1 y1 x2 y2 depth)
;; - x1 y1 is start point
;; - angle of this line, in radians
;; - depth, depth within tree (controls length of line)
(define (create-tree x1 y1 angle depth)
  (define (degrees->radians d)
    (let ((pi 3.14159265358979323846264338327950288419716939937510582097))
      (* d pi 1/180)))
  ;
  (if (zero? depth)
    '()
    (let ((x2 (+ x1 (* (cos (degrees->radians angle)) depth *scale*)))
          (y2 (+ y1 (* (sin (degrees->radians angle)) depth *scale*))))
      (append (list (map truncate (list x1 y1 x2 y2 depth)))
              (create-tree x2 y2 (- angle *split*) (- depth 1))
              (create-tree x2 y2 (+ angle *split*) (- depth 1))))))

;; output the tree to an eps file
(define (output-tree-as-eps filename tree)
  (when (file-exists? filename) (delete-file filename))
  (with-output-to-file
    filename
    (lambda ()
      (display "%!PS-Adobe-3.0 EPSF-3.0\n%%BoundingBox: 0 0 800 800\n")

      ;; add each line - sets linewidth based on depth in tree
      (for-each (lambda (line)
                  (display
                    (string-append "newpath\n"
                                   (number->string (list-ref line 0)) " "
                                   (number->string (list-ref line 1)) " "
                                   "moveto\n"
                                   (number->string (list-ref line 2)) " "
                                   (number->string (list-ref line 3)) " "
                                   "lineto\n"
                                   (number->string (truncate (/ (list-ref line 4) 2)))
                                   " setlinewidth\n"
                                   "stroke\n"
                                   )))
                tree)
      (display "\n%%EOF"))))

(output-tree-as-eps "fractal.eps" (create-tree 400 200 90 9))
