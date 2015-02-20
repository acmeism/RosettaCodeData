#lang racket
(define lucid-sieve-size 25000) ; this should be enough to do me!
(define lucid?
  (let ((lucid-bytes-sieve
         (delay
           (define sieve-bytes (make-bytes lucid-sieve-size 1))
           (bytes-set! sieve-bytes 0 0) ; not a lucid number
           (define (sieve-pass L)
             (let loop ((idx (add1 L)) (skip (sub1 L)))
               (cond
                 [(= idx lucid-sieve-size)
                  (for/first ((rv (in-range (add1 L) lucid-sieve-size))
                              #:unless (zero? (bytes-ref sieve-bytes rv))) rv)]
                 [(zero? (bytes-ref sieve-bytes idx))
                  (loop (add1 idx) skip)]
                 [(= skip 0)
                  (bytes-set! sieve-bytes idx 0)
                  (loop (add1 idx) (sub1 L))]
                 [else (loop (add1 idx) (sub1 skip))])))
           (let loop ((l 2))
             (when l (loop (sieve-pass l))))
           sieve-bytes)))

    (λ (n) (= 1 (bytes-ref (force lucid-bytes-sieve) n)))))

(define (dnl . things) (for-each displayln things))

(dnl
 "Generate and show here the first 25 ludic numbers."
 (for/list ((_ 25) (l (sequence-filter lucid? (in-naturals)))) l)
 "How many ludic numbers are there less than or equal to 1000?"
 (for/sum ((n 1001) #:when (lucid? n)) 1)
 "Show the 2000..2005'th ludic numbers."
 (for/list ((i 2006) (l (sequence-filter lucid? (in-naturals))) #:when (>= i 2000)) l)
 #<<EOS
A triplet is any three numbers x, x + 2, x + 6 where all three numbers are
also ludic numbers. Show all triplets of ludic numbers < 250 (Stretch goal)
EOS
 (for/list ((x (in-range 250)) #:when (and (lucid? x) (lucid? (+ x 2)) (lucid? (+ x 6))))
   (list x (+ x 2) (+ x 6))))
