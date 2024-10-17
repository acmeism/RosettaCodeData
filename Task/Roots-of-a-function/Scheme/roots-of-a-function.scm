;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Finding (real) roots of a function.
;;;
;;; I follow the model that breaks the task into two distinct ones:
;;; isolating real roots, and then finding the isolated roots. The
;;; former task I will call "isolating roots", and the latter I will
;;; call "rootfinding".
;;;
;;; Isolating real roots of a polynomial can be done exactly, and the
;;; methods can handle infinite domains. Scheme (because it has exact
;;; rationals) is a relatively easy language in which to write such
;;; code.
;;;
;;; I have also isolated the roots of low-degree polynomials on finite
;;; intervals by the following method, in floating-point arithmetic:
;;; rewrite the polynomial in the Bernstein polynomials basis, then
;;; take derivatives to get critical points, working your way back up
;;; in degree from a straight line. This method goes back and forth
;;; between the two subtasks. (You could use the quadratic formula
;;; once you got down to degree two, but I wouldn’t bother. The cubic
;;; and quartic formulas are numerically very poor and should be
;;; avoided.)
;;;
;;; However, these methods require that the function be a
;;; polynomial. Here I will simply use a step size and the
;;; intermediate value theorem.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(cond-expand
  (r7rs)
  (chicken (import r7rs)))

;;;
;;; Step 1. Isolation of roots.
;;;
;;; I will simply step over the domain and look for intervals that
;;; contain at least one root. There is a risk of getting the error
;;; message "the root is not bracketed" when you run the
;;; rootfinder. (One could have the rootfinder raise a recoverable
;;; exception or return a special value, instead.)
;;;
(define-library (isolate-roots)

  (export isolate-roots)

  (import (scheme base))

  (begin

    (define (isolate-roots f x-min x-max x-step)
      (define (ith-x i) (+ x-min (* i x-step)))
      (let ((x0 x-min)
            (y0 (f x-min)))
        (let loop ((i1 1)
                   (x0 x0)
                   (y0 y0)
                   (accum (if (zero? y0)
                              `((,x0 . ,x0))
                              '())))
          (let ((x1 (ith-x i1)))
            (if (< x-max x1)
                (reverse accum)
                (let ((y1 (f x1)))
                  (cond
                   ((zero? y1)
                    (loop (+ i1 1) x1 y1 `((,x1 . ,x1) . ,accum)))
                   ((negative? (* y0 y1))
                    (loop (+ i1 1) x1 y1 `((,x0 . ,x1) . ,accum)))
                   (else
                    (loop (+ i1 1) x1 y1 accum)))))))))

    )) ;; end library roots-isolator

;;;
;;; Step 2. Rootfinding.
;;;
;;; I will use the ITP method. I wrote this implementation shortly
;;; after the algorithm was published. See
;;; https://sourceforge.net/p/chemoelectric/itp-root-finder
;;;
;;; Reference:
;;;
;;;   I.F.D. Oliveira and R.H.C. Takahashi. 2020. An Enhancement of
;;;   the Bisection Method Average Performance Preserving Minmax
;;;   Optimality. ACM Trans. Math. Softw. 47, 1, Article 5 (December
;;;   2020), 24 pages. https://doi.org/10.1145/3423597
;;;
(define-library (itp-root-finder)

  (export itp-root-finder-epsilon
          itp-root-finder-extra-steps
          itp-root-finder-kappa1
          itp-root-finder-kappa2

          ;; itp-root-bracket-finder returns two values that form a
          ;; bracket no wider than 2ϵ.
          itp-root-bracket-finder

          ;; itp-root-finder returns the point midway between the ends
          ;; of the final bracket.
          itp-root-finder)

  (import (scheme base))
  (import (scheme inexact))
  (import (scheme case-lambda))
  (import (srfi 143))                   ; Fixnums.
  (import (srfi 144))                   ; Flonums.

  (begin

    (define ϕ
      ;; The Golden Ratio, (1 + √5)/2, rounded down by about
      ;; 0.00003398875.
      1.618)

    (define 1+ϕ (+ 1.0 ϕ))

    (define itp-root-finder-epsilon
      (make-parameter
       (* 1000.0 fl-epsilon)
       (lambda (ϵ)
         (if (positive? ϵ)
             ϵ
             (error 'itp-root-finder-epsilon
                    "a positive value was expected"
                    ϵ)))))

    (define itp-root-finder-extra-steps
      ;; Increase extra-steps above zero, if you wish to try to speed
      ;; up convergence, at the expense of that many more steps in the
      ;; worst case.
      (make-parameter
       0
       (lambda (n₀)
         (if (or (negative? n₀) (not (integer? n₀)))
             (error 'itp-root-finder-extra-steps
                    "a non-negative integer was expected"
                    n₀)
             n₀))))

    (define itp-root-finder-kappa1
      (make-parameter
       0.1
       (lambda (κ₁)
         (if (positive? κ₁)
             κ₁
             (error 'itp-root-finder-kappa1
                    "a positive value was expected"
                    κ₁)))))

    (define itp-root-finder-kappa2
      (make-parameter
       2.0
       (lambda (κ₂)
         (if (or (< κ₂ 1) (< 1+ϕ κ₂))
             ;; We allow <= 1+ϕ (instead of ‘< 1+ϕ’) because we
             ;; already rounded ϕ down.
             (error 'itp-root-finder-kappa2
                    (string-append "a value 1 <= kappa2 <= "
                                   (number->string 1+ϕ)
                                   " was expected")
                    κ₂)
             κ₂))))

    (define (sign x)
      (cond ((negative? x) -1)
            ((positive? x) 1)
            (else 0)))

    (define (apply-sign σ x)
      (cond ((fxnegative? σ) (- x))
            ((fxpositive? σ) x)
            (else 0)))

    (define (itp-root-bracket-finder%% f a b ϵ n₀ κ₁ κ₂)
      (let* ((2ϵ (inexact (* 2 ϵ)))
             (n½ (exact (ceiling (log (/ (inexact (- b a)) 2ϵ) 2))))
             (n_max (+ n½ n₀))
             (ya (f a))
             (yb (f b))
             (σ_ya (sign ya))
             (σ_yb (sign yb)))
        (cond
         ((fxzero? σ_ya) (values a a))
         ((fxzero? σ_yb) (values b b))
         (else
          (when (fxpositive? (* σ_ya σ_yb))
            (error 'itp-root-bracket-finder
                   "the root is not bracketed"
                   a b))
          (let loop ((pow2 (expt 2 n_max))
                     (a (inexact a))
                     (b (inexact b))
                     (ya (inexact ya))
                     (yb (inexact yb)))
            (if (or (= pow2 1) (fl<=? (fl- b a) 2ϵ))
                (values a b)
                (let* ( ;; x½ – the bisection.
                       (x½ (fl* 0.5 (fl+ a b)))

                       ;; xf – interpolation by regula falsi.
                       (xf (fl/ (fl- (fl* yb a) (fl* ya b))
                                (fl- yb ya)))

                       (b-a (fl- b a))
                       (δ (fl* κ₁ (flabs (expt b-a κ₂))))
                       (x½-xf (fl- x½ xf))
                       (σ (sign x½-xf))

                       ;; xt – the ‘truncation’ of xf.
                       (xt (if (fl<=? δ (flabs x½-xf))
                               (fl+ xf (apply-sign σ δ))
                               x½))

                       (r (- (* pow2 ϵ) (fl* 0.5 b-a)))

                       ;; xp – the projection of xt onto [x½-r,x½+r].
                       (xp (if (fl<=? (flabs (fl- xt x½)) r)
                               xt
                               (fl- x½ (apply-sign σ r))))

                       (yp (inexact (f xp))))

                  (let ((pow2/2 (truncate-quotient pow2 2))
                        (σ_yp (sign yp)))

                    (cond ((fx=? σ_ya σ_yp)
                           ;; yp has the same sign as ya. Make it the
                           ;; new ya.
                           (loop pow2/2 xp b yp yb))

                          ((fx=? σ_yb σ_yp)
                           ;; yp has the same sign as yb. Make it the
                           ;; new yb.
                           (loop pow2/2 a xp ya yp))

                          (else
                           ;; yp is zero.
                           (values xp xp)))))))))))

    (define (itp-root-bracket-finder% f a b ϵ n₀ κ₁ κ₂)
      (cond
       ((< b a) (itp-root-bracket-finder% b a f ϵ n₀ κ₁ κ₂))
       (else
        (let* ((ϵ (or ϵ (itp-root-finder-epsilon)))
               (n₀ (or n₀ (itp-root-finder-extra-steps)))
               (κ₁ (or κ₁ (itp-root-finder-kappa1)))
               (κ₂ (or κ₂ (itp-root-finder-kappa2))))
          (when (negative? ϵ)
            (error 'itp-root-bracket-finder
                   "a positive value was expected" ϵ))
          (when (negative? κ₁)
            (error 'itp-root-bracket-finder
                   "a positive value was expected" κ₁))
          (when (or (< κ₂ 1) (< 1+ϕ κ₂))
            ;; We allow <= 1+ϕ (instead of ‘< 1+ϕ’) because we already
            ;; rounded ϕ down.
            (error 'itp-root-bracket-finder
                   (string-append "a value 1 <= kappa2 <= "
                                  (number->string 1+ϕ)
                                  " was expected")
                   κ₂))
          (when (or (negative? n₀) (not (integer? n₀)))
            (error 'itp-root-bracket-finder
                   "a non-negative integer was expected" n₀))
          (itp-root-bracket-finder%% f a b ϵ n₀ κ₁ κ₂)))))

    (define itp-root-bracket-finder
      (case-lambda
        ((f a b)
         (itp-root-bracket-finder% f a b #f #f #f #f))
        ((f a b ϵ)
         (itp-root-bracket-finder% f a b ϵ #f #f #f))
        ((f a b ϵ n₀)
         (itp-root-bracket-finder% f a b ϵ n₀ #f #f))
        ((f a b ϵ n₀ κ₁)
         (itp-root-bracket-finder% f a b ϵ n₀ κ₁ #f))
        ((f a b ϵ n₀ κ₁ κ₂)
         (itp-root-bracket-finder% f a b ϵ n₀ κ₁ κ₂))))

    (define (itp-root-finder% f a b ϵ n₀ κ₁ κ₂)
      (call-with-values
          (lambda ()
            (itp-root-bracket-finder f a b ϵ n₀ κ₁ κ₂))
        (lambda (a b)
          (if (= a b)
              a
              (* 0.5 (+ a b))))))

    (define itp-root-finder
      (case-lambda
        ((f a b)
         (itp-root-finder% f a b #f #f #f #f))
        ((f a b ϵ)
         (itp-root-finder% f a b ϵ #f #f #f))
        ((f a b ϵ n₀)
         (itp-root-finder% f a b ϵ n₀ #f #f))
        ((f a b ϵ n₀ κ₁)
         (itp-root-finder% f a b ϵ n₀ κ₁ #f))
        ((f a b ϵ n₀ κ₁ κ₂)
         (itp-root-finder% f a b ϵ n₀ κ₁ κ₂))))

    )) ;; end library itp-root-finder

(import (scheme base))
(import (scheme write))
(import (isolate-roots))
(import (itp-root-finder))

(define (f x)
  ;; x³ - 3x² + 2x, written in Horner form.
  (* x (+ 2 (* x (+ -3 x)))))

(define (find-root f interval)
  (define (display-exactness root)
    (display (if (and (exact? root)
                      (exact? (f root))
                      (zero? (f root)))
                 "  (exact)    "
                 "  (inexact)  ")))
  (let ((x0 (car interval))
        (x1 (cdr interval)))
    (if (= x0 x1)
        (begin
          (let ((root (if (exact? x0) x0 x1)))
            (display-exactness root)
            (display "(rootfinder not used)  ")
            (display root)
            (newline)))
        (begin
          ;;
          ;; I am not careful here to avoid accidentally excluding the
          ;; root from the bracketing interval [x0,x1]. Floating point
          ;; is very tricky to work with.
          ;;
          (let ((root (itp-root-finder f x0 x1)))
            (display-exactness root)
            (display "(rootfinder used)      ")
            (display root)
            (newline))))))

;;; The following two demonstrations find all three roots exactly, as
;;; exact rationals, without the need for a rootfinding step.
(newline)
(display "Stepping by 1/1000 from 0 to 2:")
(newline)
(do ((p (isolate-roots f 0 2 1/1000) (cdr p)))
    ((not (pair? p)))
  (find-root f (car p)))
(newline)
(display "Stepping by 1/1000 from -10 to 10:")
(newline)
(do ((p (isolate-roots f -10 10 1/1000) (cdr p)))
    ((not (pair? p)))
  (find-root f (car p)))

;;; The following demonstration gives inexact results, because the
;;; step size is an inexact number.
(newline)
(display "Stepping by 0.001 from -10.0 to 10.0:")
(newline)
(do ((p (isolate-roots f -10.0 10.0 0.001) (cdr p)))
    ((not (pair? p)))
  (find-root f (car p)))

;;; The following demonstration gives inexact results, because the
;;; rootfinder is needed.
(newline)
(display "Stepping by 13/3333 from -2111/1011 to 33/13:")
(newline)
(do ((p (isolate-roots f -2111/1011 33/13 13/3333) (cdr p)))
    ((not (pair? p)))
  (find-root f (car p)))

(newline)
