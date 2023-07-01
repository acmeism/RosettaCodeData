#lang racket
(require math)

(define random-normal
  (let ([unit (uniform-dist)]
        [next #f])
    (λ (μ σ)
      (if next
          (begin0
            (+ μ (* σ next))
            (set! next #f))
          (let loop ()
            (let* ([v1 (- (* 2.0 (sample unit)) 1.0)]
                   [v2 (- (* 2.0 (sample unit)) 1.0)]
                   [s (+ (sqr v1) (sqr v2))])
              (cond [(>= s 1) (loop)]
                    [else (define scale (sqrt (/ (* -2.0 (log s)) s)))
                          (set! next (* scale v2))
                          (+ μ (* σ scale v1))])))))))
