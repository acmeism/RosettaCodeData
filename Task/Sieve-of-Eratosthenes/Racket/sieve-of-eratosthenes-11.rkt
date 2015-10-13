#lang racket
(require racket/generator)
(define (ints-from i d)
  (generator () (let loop ([i i]) (yield i) (loop (+ i d)))))
(define (merge g1 g2)
  (generator ()
    (let loop ([x1 (g1)] [x2 (g2)])
      (cond [(< x1 x2) (yield x1) (loop (g1) x2)]
            [(> x1 x2) (yield x2) (loop x1 (g2))]
            [else      (yield x1) (loop (g1) (g2))]))))
(define (sieve l non-primes)
  (generator ()
    (let loop ([x (l)] [np (non-primes)])
      (cond [(< np x) (loop x (non-primes))]
            [(= np x) (loop (l) (non-primes))]
            [else (yield x)
                  (set! non-primes (merge (ints-from (* x x) x) non-primes))
                  (loop (l) (non-primes))]))))
(define (cons x l) (generator () (yield x) (let loop () (yield (l)) (loop))))
(define primes (cons 2 (sieve (ints-from 3 2) (ints-from 2 2))))
(for/list ([i 25] [x (in-producer primes)]) x)
