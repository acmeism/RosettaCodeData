#lang racket
(require math/number-theory)

;; 1. coefficients of expanded polynomial (x-1)^p
;;    produces a vector because in-vector can provide a start
;;    and stop (of 1 and p) which allow us to drop the (-1)^p
;;    and the x^p terms, respectively.
;;
;;    (vector-ref (coefficients p) e) is the coefficient for p^e
(define (coefficients p)
  (for/vector ((e (in-range 0 (add1 p))))
    (define sign (expt -1 (- p e)))
    (* sign (binomial p e))))

;; 2. Show the polynomial expansions from p=0 .. 7 (inclusive)
;; (it's possible some of these can be merged...)
(define (format-coefficient c e leftmost?)
  (define (format-c.x^e c e)
    (define +c (abs c))
    (match* (+c e)
      [(_ 0) (format "~a" +c)]
      [(1 _) (format "x^~a" e)]
      [(_ _) (format "~ax^~a" +c e)]))
  (define +/- (if (negative? c) "-" "+"))
  (define +c.x^e (format-c.x^e c e))
  (match* (c e leftmost?)
    [(0 _ _) ""]
    [((? negative?) _ #t) (format "-~a" +c.x^e)]
    [(_ _ #t) +c.x^e]
    [(_ _ _) (format " ~a ~a" +/- +c.x^e)]))

(define (format-polynomial cs)
  (define cs-length (sequence-length cs))
  (apply
   string-append
   (reverse ; convention is to display highest exponent first
    (for/list ((c cs) (e (in-naturals)))
      (format-coefficient c e (= e (sub1 cs-length)))))))

(for ((p (in-range 0 (add1 11))))
  (printf "p=~a: ~a~%" p (format-polynomial (coefficients p))))

;; 3. AKS primeality test
(define (prime?/AKS p)
  (define cs (coefficients p))
  (and
   (or (= (vector-ref cs 0) -1) ; c_0 = -1 -> c_0 - (-1) = 0
       (divides? p 2))        ; c_0 = 1 -> c_0 - (-1) = 2 -> divides?
   (for/and ((c (in-vector cs 1 p))) (divides? p c))))

;; there is some discussion (see Discussion) about what to do with the perennial "1"
;; case. This is my way of saying that I'm ignoring it
(define lowest-tested-number 2)

;; 4. list of numbers < 35 that are prime (note that 1 is prime
;;    by the definition of the AKS test for primes):
(displayln (for/list ((i (in-range lowest-tested-number 35)) #:when (prime?/AKS i)) i))

;; 5. stretch goal: all prime numbers under 50
(displayln (for/list ((i (in-range lowest-tested-number 50)) #:when (prime?/AKS i)) i))
(displayln (for/list ((i (in-range lowest-tested-number 100)) #:when (prime?/AKS i)) i))
