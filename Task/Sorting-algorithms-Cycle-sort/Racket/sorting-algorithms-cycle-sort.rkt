#lang racket/base
(require racket/match)

;; Sort an array in place and return the number of writes.
(define (cycle-sort! v < =?)
  (define v-len (vector-length v))
  (for/sum ; Loop through the array to find cycles to rotate.
    ((cycle-start (in-range 0 (sub1 v-len))))
    (define item (vector-ref v cycle-start))
    (define (find-insertion-point) ; Find where to put the item.
      (+ cycle-start
         (for/sum
           ((i (in-range (add1 cycle-start) v-len))
            #:when (< (vector-ref v i) item)) 1)))
    ;; Put the item there or right after any duplicates
    (define (insert-after-duplicates pos)
      (match (vector-ref v pos)
        [(== item =?) (insert-after-duplicates (add1 pos))]
        [tmp (vector-set! v pos item) ; / swap
             (set! item tmp)          ; \ [this is my only write point]
             pos]))

    (define i-p (find-insertion-point))
    (if (= i-p cycle-start)
        0 ; If the item is already there, this is not a cycle.
        (let loop ; Rotate the rest of the cycle.
          ((e-p (insert-after-duplicates i-p))
           (W 1 #| we've already written once |#))
          (if (= e-p cycle-start)
              W
              (loop (insert-after-duplicates (find-insertion-point))
                    (add1 W))))))) ; we've written again!

(module+ main
  ;; This will be random with duplicates
  (define A (list->vector (build-list 30 (λ (i) (random 20)))))
  A
  (cycle-sort! A < =)
  A
  (define B #(1 1 1 1 1 1))
  B
  (cycle-sort! B < =))
