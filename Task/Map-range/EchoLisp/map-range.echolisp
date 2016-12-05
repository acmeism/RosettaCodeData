(lib 'plot) ;; interpolation functions
(lib 'compile)

;; rational version
(define (q-map-range x xmin xmax ymin ymax) (+ ymin (/ ( * (- x xmin) (- ymax ymin)) (- xmax xmin))))

;; float version
(define (map-range x xmin xmax ymin ymax) (+ ymin (// ( * (- x xmin) (- ymax ymin)) (- xmax xmin))))
; accelerate it
(compile 'map-range "-vf")

(q-map-range 4 0 10 -1 0)
    → -3/5
(map-range 4 0 10 -1 0)
    → -0.6
(linear 4 0 10 -1 0) ;; native
    → -0.6

(for [(x (in-range 0 10))] (writeln x (q-map-range x 0 10 -1 0) (map-range x 0 10 -1 0)))

0     -1     -1
1     -9/10     -0.9
2     -4/5     -0.8
3     -7/10     -0.7
4     -3/5     -0.6
5     -1/2     -0.5
6     -2/5     -0.4
7     -3/10     -0.3
8     -1/5     -0.2
9     -1/10     -0.1
