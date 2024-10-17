(import (scheme base)
        (scheme complex)
        (rebottled pstk))

; settings for spiral
(define *resolution* 0.01)
(define *count* 2000)
(define *a* 10)
(define *b* 10)
(define *center*
  (let ((size 200)) ; change this to alter size of display
    (* size 1+i)))

(define (draw-spiral canvas)
  (define (coords theta)
    (let ((r (+ *a* (* *b* theta))))
      (make-polar r theta)))
  ;
  (do ((i 0 (+ i 1))) ; loop to draw spiral
    ((= i *count*) )
    (let ((c (+ (coords (* i *resolution*)) *center*)))
      (canvas 'create 'line
              (real-part c) (imag-part c)
              (+ 1 (real-part c)) (imag-part c)))))

(let ((tk (tk-start)))
  (tk/wm 'title tk "Archimedean Spiral")
  (let ((canvas (tk 'create-widget 'canvas)))
    (tk/pack canvas)
    (canvas 'configure
            'height: (* 2 (real-part *center*))
            'width: (* 2 (imag-part *center*)))
    (draw-spiral canvas))
  (tk-event-loop tk))
