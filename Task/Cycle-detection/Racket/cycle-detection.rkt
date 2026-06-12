#lang racket/base

;; returns (values lambda mu)
(define (brent f x0)
  ;; main phase: search successive powers of two
  (define λ
    (let main-phase ((power 1)
                     (λ 1)
                     (tortoise x0)
                     (hare (f x0))) ;; f(x0) is the element/node next to x0.
      (cond [(= hare tortoise) λ]
            ;; time to start a new power of two?
            [(= power λ) (main-phase (* power 2) 1 hare (f hare))]
            [else (main-phase power (add1 λ) tortoise (f hare))])))

  (values
   λ
   ;; Find the position of the first repetition of length λ
   (let race ((µ 0)
              (tortoise x0)
              ;; The distance between the hare and tortoise is now λ.
              (hare (for/fold ((hare x0)) ((_ (in-range λ))) (f hare))))
     ;; Next, the hare and tortoise move at same speed until they agree
     (if (= tortoise hare) µ (race (add1 µ) (f tortoise) (f hare))))))

(module+ test
  (require rackunit racket/generator)
  (define (f x) (modulo (+ (* x x) 1) 255))
  (define (make-generator f x0)
    (generator () (let loop ((x x0)) (yield x) (loop (f x)))))

  (define g (make-generator f 3))

  (define l (for/list ((_ 20)) (g)))
  (check-equal? l '(3 10 101 2 5 26 167 95 101 2 5 26 167 95 101 2 5 26 167 95))
  (displayln l)
  (let-values (([µ λ] (brent f 3)))
    (printf "Cycle length = ~a~%Start Index = ~a~%" µ λ)))
