#lang typed/racket

(define-type ChurchNat (All (x) (-> (-> x x) (-> x x))))

(: zero ChurchNat)
(define zero (λ (f) (λ (x) x)))

(: one ChurchNat)
(define one (λ (f) f))

(: succ (-> ChurchNat ChurchNat))
(: succ* (-> ChurchNat ChurchNat))
(define succ (λ (n) (λ (f) (λ (x) (f ((n f) x))))))
(define succ* (λ (n) (λ (f) (λ (x) ((n f) (f x)))))) ; different impl

(: add (-> ChurchNat (-> ChurchNat ChurchNat)))
(: add* (-> ChurchNat (-> ChurchNat ChurchNat)))
(define add (λ (n) (λ (m) (λ (f) (λ (x) ((m f) ((n f) x)))))))
(define add* (λ (n) (n succ)))

(: succ** (-> ChurchNat ChurchNat))
(define succ** (add one))

(: mult (-> ChurchNat (-> ChurchNat ChurchNat)))
(: mult* (-> ChurchNat (-> ChurchNat ChurchNat)))
(define mult (λ (n) (λ (m) (λ (f) (m (n f))))))
(define mult* (λ (n) (λ (m) ((m (add n)) zero))))

(: expt (-> ChurchNat (-> ChurchNat ChurchNat)))
(define expt (λ (n) (λ (m) ((m (mult n)) one))))

(: nat->church (-> Natural ChurchNat))
(define (nat->church n)
  (cond
    [(zero? n) zero]
    [else (succ (nat->church (sub1 n)))]))

(: church->nat (-> ChurchNat Natural))
(define (church->nat n) (((inst n Natural) add1) 0))

(: three ChurchNat)
(: four ChurchNat)
(define three (nat->church 3))
(define four (nat->church 4))

(church->nat ((add three) four))
(church->nat ((mult three) four))
(church->nat ((expt three) four))
(church->nat ((expt four) three))
