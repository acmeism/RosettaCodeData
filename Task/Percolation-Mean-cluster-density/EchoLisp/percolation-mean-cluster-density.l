(define-constant BLACK  (rgb 0 0 0.6))
(define-constant WHITE -1)
;; sets pixels to clusterize to WHITE
;; returns bit-map vector
(define (init-C n p )
    (plot-size n n)
    (define C (pixels->int32-vector )) ;; get canvas bit-map
    (pixels-map (lambda (x y) (if (< (random) p) WHITE BLACK )) C)
    C )

;; random color for new cluster
(define (new-color)
    (hsv->rgb (random) 0.9 0.9))

;; make-region predicate
(define (in-cluster C x y)
    (= (pixel-ref C x y) WHITE))

;; paint all adjacents to (x0,y0) with new color
(define (make-cluster C x0 y0)
                (pixel-set! C x0 y0 (new-color))
                (make-region in-cluster C x0 y0))

;; task
(define (make-clusters (n 400) (p 0.5))
    (define Cn 0)
    (define C null)
        (for ((t 5)) ;; 5 iterations
        (plot-clear)
        (set!  C (init-C n p))
        (for* ((x0 n) (y0 n))
            #:when  (= (pixel-ref C x0 y0) WHITE)
            (set! Cn (1+ Cn))
         (make-cluster C x0 y0)))

    (writeln 'n n  'Cn Cn  'density  (// Cn (* n n) 5) )
    (vector->pixels C)) ;; to screen
