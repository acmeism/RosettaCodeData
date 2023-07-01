#lang racket
;; ---------------------------------------------------------------------------------------------------
;; There are two distinct requirements here...
;; 1. to test for emirp-primality - this can be done as easily as testing for primality.
;;    We use math/number-theory's "prime?" for this, which has no bounds
;; 2. to find the nth emirp-prime. Even when were doing this with normal primes, we wouldn't test
;;    each number; rather sieve them. Prime sieves by their very nature are at least memory bound...
;;    so I'm happy in this case that they are kept within the bounds of "fixnum" integers. Once we
;;    accept that, we can use the unsafe-ops on fixnums which allow for a performance boost. The
;;    fixnum / sieve code is after this simpler stuff.
;; ---------------------------------------------------------------------------------------------------
(require math/number-theory)

;; this slows things down, having to unbox, test and rebox the m.p.g -- but the task asks for some
;; accounting to be performed, so account we do!
(define max-prime-tested (box 0))

(define (report-mpg)
  (printf "Max prime tested (using math/number-theory): ~a~%" (unbox max-prime-tested)))

(define (prime?/remember-max n)
  (define rv (prime? n))
  (when (and rv (> n (unbox max-prime-tested))) (set-box! max-prime-tested n))
  rv)

(define (stigid n)
  (define (inner-stigid n a) (if (= 0 n) a (inner-stigid (quotient n 10) (+ (* 10 a) (modulo n 10)))))
  (inner-stigid n 0))

(define (emirp-prime? n)
  (define u (stigid n))
  (and (not (= u n)) (prime?/remember-max n) (prime?/remember-max u)))

;; ---------------------------------------------------------------------------------------------------
(require
  racket/require
  (except-in
   (filtered-in (lambda (n) (regexp-replace #rx"unsafe-" n "")) racket/unsafe/ops) unbox set-box!))

;; NB using fixnum below limits stigid to "fixnum" (about 2^60) range of numbers
;; but, unleashed, unsafe-fx... are fast
(define (fxstigid n)
  (define (inner-fxstigid n a)
    (if (fx= 0 n) a (inner-fxstigid (fxquotient n 10) (fx+ (fx* 10 a) (fxmodulo n 10)))))
  (inner-fxstigid n 0))

;; Grows the sieve to n (so n is included in the sieve)
;; Values in the sieve are: = 0 - known non-prime
;;                          > 0 - known prime
;; The new sieve does not alter non-zero values in the old sieve; to preserve cachceing of e.g. emirps
;; Always returns a copy (so it is caller responsibility to determine the necessity of this function)
(define (extend-prime-sieve sieve n)
  (define sieve-size (bytes-length sieve))
  (define sieve-size+ (fx+ 1 n))
  (define new-sieve (make-bytes sieve-size+ 1))
  (bytes-copy! new-sieve 0 sieve 0 (fxmin sieve-size+ sieve-size))
  (for* ((f (in-range 2 (add1 (integer-sqrt sieve-size+))))
         #:unless (fx= (bytes-ref new-sieve f) 0) ; the only case of non-prime
         (f+ (in-range (fx* f (fxmax 2 (fxquotient sieve-size f))) sieve-size+ f)))
    (bytes-set! new-sieve f+ 0))
  (values sieve-size+ new-sieve))

;; task three *needs* a sieve to operate sub-second:
;; values in sieve are:
;;   0 - known non-prime
;;   1 - known prime, unknown emirp-ality (freshly generated from extend-prime-sieve)
;;   2 - known prime, known non-emirp -- needed for sieve extension
;;   3 - known emirp (and .: known prime)
(define-values
  (emirp-prime?/sieve reset-sieve! report-mpg/sieved extend-sieve!)
  (let [(sieve-size 2) (the-sieve (bytes 0 0))]
    (define (extend-sieve! n)
      (when (fx>= n sieve-size)
        (define-values (sieve-size+ new-sieve) (extend-prime-sieve the-sieve n))
        (set! the-sieve new-sieve) (set! sieve-size sieve-size+)))
    (values
     (lambda (n)
       (extend-sieve! n)
       (case (bytes-ref the-sieve n)
         [(0) #f] ; it's not even prime
         [(1) ; it's a prime... but is is emirp?
          (define u (fxstigid n))
          (define new-sieve-n
            (cond
              [(fx= u n) 2]
              [(fx> u n) (if (emirp-prime?/sieve u) 3 2)]
              [(fx= (bytes-ref the-sieve u) 1) 3]
              [else 2]))
          (bytes-set! the-sieve n new-sieve-n)
          (fx= new-sieve-n 3)]
         [(2) #f] ; we know it's not emirp
         [(3) #t])) ; we already knew it's an emirp
     (lambda () (set! sieve-size 2) (set! the-sieve (bytes 0 0)))
     (lambda () (printf "Sieve size: ~a~%Max prime generated (sieve): ~a~%" sieve-size
                        (for/last ((n the-sieve) (p (in-naturals)) #:unless (fx= 0 n)) p)))
     extend-sieve!)))

;; ---------------------------------------------------------------------------------------------------
;; testing *-primality is a lot cheaper than generating, and we'll use math/number-theory to do
;; this... it's fast enough. Because they cannot be palindromic and because 2 is the only even prime
;; (and is palindromic), all emirps are odd - hence our sequences starting with an odd (>= 11),
;; stepping by 2.
(define (task1 (emirp?-test emirp-prime?))
  (printf "\"show the first twenty emirps.\" [~s]~%" emirp?-test)
  (for/list ((n (sequence-filter emirp?-test (in-range 11 +Inf.0 2))) (_ (in-range 20))) n))

(define (task2 (emirp?-test emirp-prime?))
  (printf "\"show all emirps between 7,700 and 8,000\" [~s]~%" emirp?-test)
  (for/list ((n (sequence-filter emirp?-test (in-range 7701 8000 2)))) n))

(define (task3 (emirp?-test emirp-prime?) (extend-sieve-fn #f))
  (printf "\"show the 10,000th emirp\" [~s]~%" emirp?-test)
  (when extend-sieve-fn
    (extend-sieve-fn (nth-prime 10000))) ; at a guess, the 10000th emirp will be > the 10000th prime
  (let loop ((i 10000) (p 9))
    (define p+2 (fx+ p 2))
    (cond [(not (emirp?-test p+2)) (loop i p+2)] [(fx= i 1) p+2] [else (loop (fx- i 1) p+2)])))

;; -| MAIN |------------------------------------------------------------------------------------------
(provide main)
(define (main task)
  ;; to avoid the *necessity* of calling from the command line multiple times, we reset the sieve on
  ;; each invocation of main
  (reset-sieve!)
  (set-box! max-prime-tested 0)
  (match task
    ["1" (displayln (task1)) (report-mpg)]
    ["2" (displayln (task2)) (report-mpg)]
    ["3" (displayln (task3 emirp-prime?/sieve extend-sieve!)) (report-mpg/sieved)]))

;; -| TESTS |-----------------------------------------------------------------------------------------
(module+ test
  (require rackunit)
  (check-false (emirp-prime?/sieve 12))
  (check-false (emirp-prime?/sieve 23))
  (check-true (emirp-prime?/sieve 13))
  (check-equal?
   (for/list
       ((n (sequence-filter emirp-prime?/sieve (in-range 11 100000 2)))
        (_ (in-range 3))) n)
   '(13 17 31))
  (check-equal? (time (task1 emirp-prime?/sieve)) (time (task1)))
  (check-equal? (time (task2 emirp-prime?/sieve)) (time (task2)))
  (check-equal? (time (task3 emirp-prime?/sieve extend-sieve!)) (time (task3))))
