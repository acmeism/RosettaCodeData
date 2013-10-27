(require racket/gui)
(require 'sutherland-hodgman)

(define (make-points pt-list)
    (for/list ([p pt-list])
      (make-object point% (point-x p) (point-y p))))

(define subject-poly-points
    (list (point 50 150)  (point 200 50)  (point 350 150)
          (point 350 300) (point 250 300) (point 200 250)
          (point 150 350) (point 100 250) (point 100 200)))

(define clip-poly-points
    (list (point 100 100)
          (point 300 100)
          (point 300 300)
          (point 100 300)))

(define clip-poly-edges
    (make-edges clip-poly-points))

(define (run)
  (let* ([frame (new frame% [label "Sutherland-Hodgman racket demo"]
		     [width 320]
		     [height 320])]
	 [canvas (new canvas% [parent frame])]
	 [dc (send canvas get-dc)]
         [clipped-poly (clip-to subject-poly-points clip-poly-edges)])

    (send frame show #t)
    (sleep/yield 1)

    (send dc set-pen (make-pen
                        #:color (send the-color-database find-color "Blue")
                        #:width 3))
    (send dc draw-polygon (make-points subject-poly-points))
    (send dc set-pen (make-pen
                        #:color (send the-color-database find-color "Red")
                        #:width 4
                        #:style 'long-dash))
    (send dc draw-polygon (make-points clip-poly-points))
    (send dc set-pen (make-pen
                        #:color (send the-color-database find-color "Green")))
    (send dc set-brush (make-brush
                        #:color (send the-color-database find-color "Green")
                        #:style 'solid))
    (send dc draw-polygon (make-points clipped-poly))
    clipped-poly))

(run)
