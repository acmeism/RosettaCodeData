#lang racket

(require math/number-theory)

;; math/number-theory allows us to parameterize a "current-modulus"
;; which obviates the need for p to be passed around constantly
(define (Cipolla n p) (with-modulus p (mod-Cipolla n)))

(define (mod-Legendre a)
  (modexpt a (/ (sub1 (current-modulus)) 2)))

;; Arithmetic in Fp²
(struct Fp² (x y))

(define-syntax-rule (Fp²-destruct* (a a.x a.y) ...)
  (begin (match-define (Fp² a.x a.y) a) ...)  )

;; a + b
(define (Fp²-add a b ω2)
  (Fp²-destruct* (a a.x a.y) (b b.x b.y))
  (Fp² (mod+ a.x b.x) (mod+ a.y b.y)))

;; a * b
(define (Fp²-mul a b ω2)
  (Fp²-destruct* (a a.x a.y) (b b.x b.y))
  (Fp² (mod+ (* a.x b.x) (* ω2 a.y b.y)) (mod+ (* a.x b.y) (* a.y b.x))))

;; a * a	
(define (Fp²-square a ω2)
  (Fp²-destruct* (a a.x a.y))
  (Fp² (mod+ (sqr a.x) (* ω2 (sqr a.y))) (mod* 2 a.x a.y)))

;; a ^ n
(define (Fp²-pow a n ω2)
  (Fp²-destruct* (a a.x a.y))
  (cond
    ((= 0 n) (Fp² 1 0))
    ((= 1 n) a)
    ((= 2 n) (Fp²-mul a a ω2))
    ((even? n) (Fp²-square (Fp²-pow a (/ n 2) ω2) ω2))
    (else (Fp²-mul a (Fp²-pow a (sub1 n) ω2) ω2))))

;; x^2 ≡ n (mod p) ?
(define (mod-Cipolla n)
  ;; check n is a square
  (unless (= 1 (mod-Legendre n)) (error 'Cipolla "~a not a square (mod ~a)" n (current-modulus)))
  ;; iterate until suitable 'a' found
  (define a (for/first ((t (in-range 2 (current-modulus))) ;; t = tentative a
                        #:when (= (sub1 (current-modulus))
                                  (mod-Legendre (- (* t t) n))))
              t))
  (define ω2 (- (* a a) n))
  ;; (Fp² a 1) = a + ω
  (define r (Fp²-pow (Fp² a 1) (/ (add1 (current-modulus)) 2) ω2))
  (define x (Fp²-x r))
  (unless (zero? (Fp²-y r)) (error 'Cipolla "ω has not vanished")) ;; hope that ω has vanished
  (unless (mod= n (* x x)) (error 'Cipolla "result check failed")) ;; checking the result
  (values x (mod- (current-modulus) x)))

(define (report-Cipolla n p)
  (with-handlers ((exn:fail? (λ (x) (eprintf "Caught error: ~s~%" (exn-message x)))))
    (define-values (r1 r2) (Cipolla n p))
    (printf "Roots of ~a are (~a,~a)  (mod ~a)~%" n  r1 r2 p)))

(module+ test
  (report-Cipolla 10 13)
  (report-Cipolla 56 101)
  (report-Cipolla 8218 10007)
  (report-Cipolla 8219 10007)
  (report-Cipolla 331575 1000003)
  (report-Cipolla 665165880 1000000007)
  (report-Cipolla 881398088036 1000000000039)
  (report-Cipolla 34035243914635549601583369544560650254325084643201
                  100000000000000000000000000000000000000000000000151))
