(define (gaussian-cluster N
                          #:stdev (σ 1)
                          #:center (r0 #(0 0))
                          #:dim (d 2))
  (for/list ([i (in-range N)])
    (define r (for/vector ([j (in-range d)]) (sample (normal-dist 0 σ))))
    (vector-map + r r0)))

(define (uniform-cluster N
                         #:radius (R 1)
                         #:center (r0 #(0 0)))
  (for/list ([i (in-range N)])
    (define r (* R (sqrt (sample (uniform-dist)))))
    (define φ (* 2 pi (sample (uniform-dist))))
    (vector-map + r0 (vector (* r (cos φ)) (* r (sin φ))))))
