(lib 'math)
(define (make-circle x0 y0 r)
    (vector x0 y0 r ))

(define-syntax-id _.radius (_ 2))
(define-syntax-id  _.x0  (_ 0))
(define-syntax-id  _.y0  (_ 1))

;; to sort circles
(define (cmp-circles a b) (> a.radius b.radius))

(define (included? circle: a circles)
    (for/or ((b circles))
        #:continue (equal? a b)
        (disk-in-disk? a b)))

;; eliminates, and sort
(define (sort-circles circles)
        (list-sort cmp-circles
          (filter (lambda(c) (not (included? c circles))) circles)))

(define circles (sort-circles
  (list (make-circle   1.6417233788  1.6121789534 0.0848270516)
        (make-circle  -1.4944608174  1.2077959613 1.1039549836)
        (make-circle   0.6110294452 -0.6907087527 0.9089162485)
        (make-circle   0.3844862411  0.2923344616 0.2375743054)
        (make-circle  -0.2495892950 -0.3832854473 1.0845181219)
        (make-circle   1.7813504266  1.6178237031 0.8162655711)
        (make-circle  -0.1985249206 -0.8343333301 0.0538864941)
        (make-circle  -1.7011985145 -0.1263820964 0.4776976918)
        (make-circle  -0.4319462812  1.4104420482 0.7886291537)
        (make-circle   0.2178372997 -0.9499557344 0.0357871187)
        (make-circle  -0.6294854565 -1.3078893852 0.7653357688)
        (make-circle   1.7952608455  0.6281269104 0.2727652452)
        (make-circle   1.4168575317  1.0683357171 1.1016025378)
        (make-circle   1.4637371396  0.9463877418 1.1846214562)
        (make-circle  -0.5263668798  1.7315156631 1.4428514068)
        (make-circle  -1.2197352481  0.9144146579 1.0727263474)
        (make-circle  -0.1389358881  0.1092805780 0.7350208828)
        (make-circle   1.5293954595  0.0030278255 1.2472867347)
        (make-circle  -0.5258728625  1.3782633069 1.3495508831)
        (make-circle  -0.1403562064  0.2437382535 1.3804956588)
        (make-circle   0.8055826339 -0.0482092025 0.3327165165)
        (make-circle  -0.6311979224  0.7184578971 0.2491045282)
        (make-circle   1.4685857879 -0.8347049536 1.3670667538)
        (make-circle  -0.6855727502  1.6465021616 1.0593087096)
        (make-circle   0.0152957411  0.0638919221 0.9771215985))))

;; bounding box
(define (enclosing-rect circles)
    (define xmin (for/min ((c circles)) (- c.x0 c.radius)))
    (define xmax (for/max ((c circles)) (+ c.x0 c.radius)))
    (define ymin (for/min ((c circles)) (- c.y0 c.radius)))
    (define ymax (for/max ((c circles)) (+ c.y0 c.radius)))
    (vector xmin ymin (- xmax xmin) (- ymax ymin)))

;; Compute surface of entirely overlapped tiles
;; and assign candidates circles to other tiles.
;; cands is a vector nsteps x nsteps of circles lists indexed by (i,j)

(define (S0 circles rect steps into: cands)
    (define dx (// (rect 2) steps)) ;; width / steps
    (define dy (// (rect 3) steps)) ;; height / steps
    (define ds (* dx dy)) ;; tile surface
    (define dr (vector (- rect.x0 dx) (- rect.y0 dy) dx dy))
    (define ijdx 0)

    (for/sum ((i steps))
        (vector+= dr 0 dx)
        (vector-set! dr 1 (- rect.y0 dy))

        (for/sum ((j steps))
        (vector+= dr 1 dy)
        (set! ijdx (+ i (* j steps)))

        (for/sum ((c circles))
            #:break (rect-in-disk? dr c) ;; enclosed ? add ds
                 => (begin   (vector-set! cands ijdx null) ds)
            #:continue (not (rect-disk-intersect? dr c))
                 ;; intersects ? add circle to candidates for this tile
            (vector-set! cands ijdx  (cons c (cands ijdx )))
            0)
    )))

(define ct 0)
;; return sum of surfaces of tiles which are not entirely overlapped
(define (S circles rect steps cands)
(++ ct)
    (define dx (// (rect 2) steps))
    (define dy (// (rect 3) steps))
    (define ds (* dx dy))
    (define dr (vector (- rect.x0 dx) (- rect.y0 dy) dx dy))
    (define ijdx 0)

    (for/sum ((i steps))
        (vector+= dr 0 dx)
        (vector-set! dr 1 (- (rect 1) dy))

        (for/sum ((j steps))
        (vector+= dr 1 dy)

        (when (!null? cands) (set! circles (cands (+ i (* j steps)))))
        #:continue (null? circles)

        ;; add surface
        (or
            (for/or ((c circles)) ;; enclosed ? add ds
            #:break (rect-in-disk? dr c) => ds
            #f )

            (if ;; not intersecting? add 0
            (for/or ((c circles))
             (rect-disk-intersect? dr c)) #f 0)

            ;; intersecting ? recurse until precision
            (when (> dx s-precision) (S circles dr 2 null))

            ;; no hope - add ds/2
            (// ds 2))
    )))
