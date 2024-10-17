;;;-------------------------------------------------------------------
;;;
;;; For R7RS Scheme, translated from the Racket.
;;;

(cond-expand
  (r7rs)
  (chicken (import r7rs)))             ; CHICKEN is not natively R7RS.

;;;-------------------------------------------------------------------
;;;
;;; A partial implementation of Icon-style co-expressions.
;;;
;;; This limited form does not implement co-expressions that receive
;;; inputs.
;;;

(define-library (suspendable-procedures)

  (export suspend)
  (export make-generator-procedure)

  (import (scheme base))

  (begin

    (define *suspend* (make-parameter (lambda (x) x)))
    (define (suspend v) ((*suspend*) v))

    (define (make-generator-procedure thunk)
      ;; This is for making a suspendable procedure that takes no
      ;; arguments when resumed. The result is a simple generator of
      ;; values.
      (define (next-run return)
        (define (my-suspend v)
          (set! return (call/cc (lambda (resumption-point)
                                  (set! next-run resumption-point)
                                  (return v)))))
        (parameterize ((*suspend* my-suspend))
          (suspend (thunk))))
      (lambda () (call/cc next-run)))

    )) ;; end library

;;;-------------------------------------------------------------------
;;;
;;; Let us decide how we wish to do integer division.
;;;

(define-library (division-procedures)
  (export div rem divrem)
  (import (scheme base))
  (begin
    (define div floor-quotient)
    (define rem floor-remainder)
    (define divrem floor/)))

;;;-------------------------------------------------------------------
;;;
;;; The Main part of the baby-NG matrices. They are implemented as
;;; R7RS (SRFI-9) records, made to look like the Racket structs.
;;;

(define-library (baby-ng-matrices)

  (export ng ng?
          ng-a1 set-ng-a1!
          ng-a set-ng-a!
          ng-b1 set-ng-b1!
          ng-b set-ng-b!)
  (export ng-ingress!
          ng-needterm?
          ng-egress!
          ng-infty!
          ng-done?)

  (import (scheme base))
  (import (division-procedures))

  (begin

    (define-record-type <ng>
      (ng a1 a b1 b)
      ng?
      (a1 ng-a1 set-ng-a1!)
      (a ng-a set-ng-a!)
      (b1 ng-b1 set-ng-b1!)
      (b ng-b set-ng-b!))

    (define (ng-ingress! v t)
      (define a (ng-a v))
      (define a1 (ng-a1 v))
      (define b (ng-b v))
      (define b1 (ng-b1 v))
      (set-ng-a! v a1)
      (set-ng-a1! v (+ a (* a1 t)))
      (set-ng-b! v b1)
      (set-ng-b1! v (+ b (* b1 t))))

    (define (ng-needterm? v)
      (or (zero? (ng-b v))
          (zero? (ng-b1 v))
          (not (= (div (ng-a v) (ng-b v))
                  (div (ng-a1 v) (ng-b1 v))))))

    (define (ng-egress! v)
      (define t (div (ng-a v) (ng-b v)))
      (define a (ng-a v))
      (define a1 (ng-a1 v))
      (define b (ng-b v))
      (define b1 (ng-b1 v))
      (set-ng-a! v b)
      (set-ng-a1! v b1)
      (set-ng-b! v (- a (* b t)))
      (set-ng-b1! v (- a1 (* b1 t)))
      t)

    (define (ng-infty! v)
      (when (ng-needterm? v)
        (set-ng-a! v (ng-a1 v))
        (set-ng-b! v (ng-b1 v))))

    (define (ng-done? v)
      (and (zero? (ng-b v))
           (zero? (ng-b1 v))))

    )) ;; end library

;;;-------------------------------------------------------------------
;;;
;;; Procedures to create generators of continued fractions. (The
;;; Racket implementations could have been adapted, but I like to use
;;; my suspendable-procedures library.)
;;;

(define-library (cf-generators)

  (export make-generator:rational->cf
          make-generator:sqrt2->cf
          make-generator:apply-baby-ng)

  (import (scheme base))
  (import (baby-ng-matrices))
  (import (suspendable-procedures))
  (import (division-procedures))

  (begin

    ;; Generate n/d.
    (define (make-generator:rational->cf n d)
      (make-generator-procedure
       (lambda ()
         (let loop ((n n)
                    (d d))
           (if (zero? d)
               (begin
                 ;; One might reasonably (suspend +inf.0) instead of
                 ;; (suspend #f)
                 (suspend #f)
                 (loop n d))
               (let-values (((q r) (divrem n d)))
                 (suspend q)
                 (loop d r)))))))

    ;; Generate sqrt(2).
    (define (make-generator:sqrt2->cf)
      (make-generator-procedure
       (lambda ()
         (suspend 1)
         (let loop ()
           (suspend 2)
           (loop)))))

    ;; Apply a baby NG to a generator, resulting in a new generator.
    (define (make-generator:apply-baby-ng ng gen)
      (make-generator-procedure
       (lambda ()
         (let loop ()
           (let ((t (gen)))
             (when t
               (ng-ingress! ng t)
               (unless (ng-needterm? ng)
                 (suspend (ng-egress! ng)))
               (loop))))
         (let loop ()
           (cond ((ng-done? ng)
                  (suspend #f)
                  (loop))
                 ((ng-needterm? ng)
                  (ng-infty! ng)
                  (loop))
                 (else
                  (suspend (ng-egress! ng))
                  (loop)))))))

    )) ;; end library

;;;-------------------------------------------------------------------
;;;
;;; Demo.
;;;

(define-library (demonstration)
  (export demonstration)

  (import (scheme base))
  (import (scheme cxr))
  (import (scheme write))
  (import (baby-ng-matrices))
  (import (cf-generators))

  (begin

    (define (display-cf max-digits)
      (lambda (gen)
        (let loop ((i 0)
                   (sep "["))
          (if (= i max-digits)
              (display ",...")
              (let ((digit (gen)))
                (when digit
                  (display sep)
                  (display digit)
                  (loop (+ i 1) (if (string=? sep "[") ";" ","))))))
        (display "]")))

    (define demonstration-instances
      (let ((rat make-generator:rational->cf)
            (sr2 make-generator:sqrt2->cf))
        `(("[1;5,2] + 1/2" ,(ng 2 1 0 2) ,(rat 13 11))
          ("[3;7] + 1/2" ,(ng 2 1 0 2) ,(rat 22 7))
          ("[3;7] / 4" ,(ng 1 0 0 4) ,(rat 22 7))
          ("sqrt(2)/2", (ng 1 0 0 2) ,(sr2))
          ("1/sqrt(2)" ,(ng 0 1 1 0) ,(sr2))
          ("(1+sqrt(2))/2" ,(ng 1 1 0 2) ,(sr2))
          ("(2+sqrt(2))/4 = (1+1/sqrt(2))/2" ,(ng 1 2 0 4) ,(sr2)))))

    (define (demonstration max-digits)
      (define dsply (display-cf max-digits))
      (do ((p demonstration-instances (cdr p)))
          ((null? p))
        (let ((expr-string (caar p))
              (baby-ng (cadar p))
              (gen (caddar p)))
          (display expr-string)
          (display " => ")
          (dsply (make-generator:apply-baby-ng baby-ng gen))
          (newline))))

    )) ;; end library

(import (demonstration))
(demonstration 20)

;;;-------------------------------------------------------------------
