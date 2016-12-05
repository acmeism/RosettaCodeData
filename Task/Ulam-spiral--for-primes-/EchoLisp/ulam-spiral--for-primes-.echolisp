(lib 'plot)

(define *red* (rgb 1 0 0))
(define (ulam n nmax) (if ( prime? n) *red* (gray (// n nmax))))
(plot-spiral ulam 1000) ;; range [0...1000]
