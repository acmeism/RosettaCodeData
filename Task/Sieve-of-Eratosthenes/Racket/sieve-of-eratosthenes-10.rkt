#lang racket
(define-syntax (define-thread-loop stx)
  (syntax-case stx ()
    [(_ (name . args) expr ...)
     (with-syntax ([out! (datum->syntax stx 'out!)])
       #'(define (name . args)
           (define out (make-channel))
           (define (out! x) (channel-put out x))
           (thread (λ() (let loop () expr ... (loop))))
           out))]))
(define-thread-loop (ints-from i d) (out! i) (set! i (+ i d)))
(define-thread-loop (merge c1 c2)
  (let loop ([x1 (channel-get c1)] [x2 (channel-get c2)])
    (cond [(> x1 x2) (out! x2) (loop x1 (channel-get c2))]
          [(< x1 x2) (out! x1) (loop (channel-get c1) x2)]
          [else      (out! x1) (loop (channel-get c1) (channel-get c2))])))
(define-thread-loop (sieve l non-primes)
  (let loop ([x (channel-get l)] [np (channel-get non-primes)])
    (cond [(> x np) (loop x (channel-get non-primes))]
          [(= x np) (loop (channel-get l) (channel-get non-primes))]
          [else     (out! x)
                    (set! non-primes (merge (ints-from (* x x) x) non-primes))
                    (loop (channel-get l)  np)])))
(define-thread-loop (cons x l)
  (out! x) (let loop () (out! (channel-get l)) (loop)))
(define primes (cons 2 (sieve (ints-from 3 1) (ints-from 4 2))))
(for/list ([i 25] [x (in-producer channel-get eof primes)]) x)
