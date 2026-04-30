(define pi (* 4 (atan 1)))

(define (->radians d) (* d (/ pi 180)))
(define (->degrees r) (* r (/ 180 pi)))

(define (average-direction angles)
  (->degrees
   ;; find the angle of the sum in radians
   (angle
    (apply + (map (lambda (d)
                    ;; a complex number on the unit circle
                    (make-polar 1 (->radians d)))
                  angles)))))

(for-each (lambda (l)
            (for-each display
                      (list "The mean angle of "
                        l
                        " is "
                        (average-direction l)
                        #\newline)))
          '((350 10)
            (90 180 270 360)
            (10 20 30)))
