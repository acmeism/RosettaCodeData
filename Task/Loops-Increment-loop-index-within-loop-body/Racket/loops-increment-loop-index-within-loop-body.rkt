#lang racket

(require math/number-theory)

(define (comma x)
  (string-join
   (reverse
    (for/list ([digit (in-list (reverse (string->list (~a x))))] [i (in-naturals)])
      (cond
        [(and (= 0 (modulo i 3)) (> i 0)) (string digit #\,)]
        [else (string digit)])))
   ""))

(let loop ([x 42] [cnt 0])
  (cond
    [(= cnt 42) (void)]
    [(prime? x) (printf "~a: ~a\n" (add1 cnt) (comma x))
                (loop (* 2 x) (add1 cnt))]
    [else (loop (add1 x) cnt)]))
