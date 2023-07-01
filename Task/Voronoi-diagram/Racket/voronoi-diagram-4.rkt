(define pts
  (for/list ([i 50]) (vector (random) (random))))

(display (plot-Voronoi-diagram pts))

(display (plot-Voronoi-diagram2 pts))

(parameterize ([metric manhattan-distance])
  (display (plot-Voronoi-diagram2 pts)))

;; Using the classification function it is possible to plot Voronoi diagram in 3D.
(define pts3d (for/list ([i 7]) (vector (random) (random) (random))))
(plot3d (list
         (isosurfaces3d (compose (classification-function pts3d) vector)
                        0 1 0 1 0 1
                        #:line-styles '(transparent)
                        #:samples 100
                        #:colors (range 7)
                        #:alphas '(1))
         (points3d pts3d #:sym 'fullcircle3)))
