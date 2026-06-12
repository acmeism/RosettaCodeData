#lang racket
(define (circle-sort v0 [<? <])
  (define v (vector-copy v0))

  (define (swap-if l r)
    (define v.l (vector-ref v l))
    (define v.r (vector-ref v r))
    (and (<? v.r v.l)
         (begin (vector-set! v l v.r) (vector-set! v r v.l) #t)))

  (define (inr-cs! L R)
    (cond
      [(>= L (- R 1)) #f] ; covers 0 or 1 vectors
      [else
       (define M (quotient (+ L R) 2))
       (define I-moved?
         (for/or ([l (in-range L M)] [r (in-range (- R 1) L -1)])
           (swap-if l r)))
       (define M-moved? (and (odd? (- L R)) (> M 0) (swap-if (- M 1) M)))
       (define L-moved? (inr-cs! L M))
       (define R-moved? (inr-cs! M R))
       (or I-moved? L-moved? R-moved? M-moved?)]))

  (let loop () (when (inr-cs! 0 (vector-length v)) (loop)))
  v)

(define (sort-random-vector)
  (define v (build-vector (+ 2 (random 10)) (λ (i) (random 100))))
  (define v< (circle-sort v <))
  (define sorted? (apply <= (vector->list v<)))
  (printf "   ~.a\n-> ~.a [~a]\n\n" v v< sorted?))

(for ([_ 10]) (sort-random-vector))

(circle-sort '#("table" "chair" "cat" "sponge") string<?)
