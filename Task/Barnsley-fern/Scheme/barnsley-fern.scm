(import (scheme base)
        (scheme cxr)
        (scheme file)
        (scheme inexact)
        (scheme write)
        (srfi 27))     ; for random numbers

(define (create-fern x y num-points)
  (define (new-point xn yn)
    (let ((r (* 100 (random-real))))
      (cond ((< r 1) ; f1
             (list 0 (* 0.16 yn)))
            ((< r 86) ; f2
             (list (+ (* 0.85 xn) (* 0.04 yn))
                   (+ (* -0.04 xn) (* 0.85 yn) 1.6)))
            ((< r 93) ; f3
             (list (- (* 0.2 xn) (* 0.26 yn))
                   (+ (* 0.23 xn) (* 0.22 yn) 1.6)))
            (else ; f4
              (list (+ (* -0.15 xn) (* 0.28 yn))
                    (+ (* 0.26 xn) (* 0.24 yn) 0.44))))))
  ;
  (random-source-randomize! default-random-source)
  (do ((i 0 (+ i 1))
       (pts (list (list x y)) (cons (new-point (caar pts) (cadar pts)) pts)))
    ((= i num-points) pts)))

;; output the fern to an eps file
(define (output-fern-as-eps filename fern)
  (when (file-exists? filename) (delete-file filename))
  (with-output-to-file
    filename
    (lambda ()
      (let* ((width 600)
             (height 800)
             (min-x (apply min (map car fern)))
             (max-x (apply max (map car fern)))
             (min-y (apply min (map cadr fern)))
             (max-y (apply max (map cadr fern)))
             (scale-x (/ (- width 50) (- max-x min-x)))
             (scale-y (/ (- height 50) (- max-y min-y)))
             (scale-points (lambda (point)
                             (list (truncate (+ 20 (* scale-x (- (car point) min-x))))
                                   (truncate (+ 20 (* scale-y (- (cadr point) min-y))))))))

        (display
          (string-append "%!PS-Adobe-3.0 EPSF-3.0\n%%BoundingBox: 0 0 "
                         (number->string width) " " (number->string height) "\n"))

        ;; add each point in fern as an arc - sets linewidth based on depth in tree
        (for-each (lambda (point)
                    (display
                      (string-append (number->string (list-ref point 0))
                                     " "
                                     (number->string (list-ref point 1))
                                     " 0.1 0 360 arc\nstroke\n")))
                  (map scale-points fern))
        (display "\n%%EOF")))))

(output-fern-as-eps "barnsley.eps" (create-fern 0 0 50000))
