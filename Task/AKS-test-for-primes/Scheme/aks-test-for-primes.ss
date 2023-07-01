;; implement mod m arithmetic with polnomials in x
;; as lists of coefficients, x^0 first.
;;
;; so x^3 + 5 is represented as (5 0 0 1)

(define (+/m m a b)
  ;; add two polynomials
  (cond ((null? a) b)
        ((null? b) a)
        (else (cons (modulo (+ (car a) (car b)) m)
                    (+/m m (cdr a) (cdr b))))))

(define (*c/m m c a)
  ;; multiplication by a constant
  (map (lambda (v) (modulo (* c v) m)) a))

(define (*/m m a b)
  ;; multiply two polynomials
  (let loop ((a a))
    (if (null? a)
        '()
        (+/m m (*c/m m (car a) b)
             (cons 0 (*/m m (cdr a) b))))))

(define (x^n/m m n)
  (if (= n 0)
      '(1)
      (cons 0 (x^n/m m (- n 1)))))

(define (^n/m m a n)
  ;; calculate the n'th power of polynomial a
  (cond ((= n 0) '(1))
        ((= n 1) a)
        (else (*/m m a (^n/m m a (- n 1))))))

;; test case
;;
;; ? lift(Mod((x^3 + 5)*(4 + 3*x + x^2),6))
;; %13 = x^5 + 3*x^4 + 4*x^3 + 5*x^2 + 3*x + 2
;;
;; > (*/m 6 '(5 0 0 1) '(4 3 1))
;; '(2 3 5 4 3 1)
;;
;; working correctly

(define (rosetta-aks-test p)
  (if (or (= p 0) (= p 1))
      #f
      ;; u = (x - 1)^p
      ;; v = (x^p - 1)
      (let ((u (^n/m p (list -1 1) p))
            (v (+/m p (x^n/m p p) (list -1))))
        (every zero? (+/m p u (*c/m p -1 v))))))

;; > (filter rosetta-aks-test (iota 50))
;; '(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47)
