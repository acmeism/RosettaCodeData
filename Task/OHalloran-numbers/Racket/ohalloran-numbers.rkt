#lang racket

(define (main)
  (let ([maximum-area 1000]
        [ohalloran-numbers (make-hash)])
    ;; Initialize the hash table
    (for ([i (in-range (quotient maximum-area 2))])
      (hash-set! ohalloran-numbers i #t))

    ;; Calculate cuboid surface areas and update the hash table
    (for* ([length (in-range 1 maximum-area)]
           [width (in-range 1 (quotient maximum-area 2))]
           [height (in-range 1 (quotient maximum-area 2))])
      (let* ([half-area (+ (* length width) (* length height) (* width height))])
        (when (< half-area (quotient maximum-area 2))
          (hash-set! ohalloran-numbers half-area #f))))

    ;; Print the results
    (printf "Values larger than 6 and less than 1,000 which cannot be the surface area of a cuboid:\n")
    (for ([i (in-range 3 (quotient maximum-area 2))])
      (when (hash-ref ohalloran-numbers i)
        (printf "~a " (* i 2))))
    (printf "\n")))

(main)
