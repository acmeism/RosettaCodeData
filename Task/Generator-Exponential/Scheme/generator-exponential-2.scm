;;; Generators using call/cc.

(cond-expand
  (r7rs)
  (chicken (import r7rs)))

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

    )) ;; end library (suspendable-procedures)

(import (scheme base))
(import (scheme case-lambda))
(import (scheme write))
(import (suspendable-procedures))

(define (make-integers-generator i0)
  (make-generator-procedure
   (lambda ()
     (let loop ((i i0))
       (suspend i)
       (loop (+ i 1))))))

(define make-nth-powers-generator
  (case-lambda
    ((n i0)
     (define next-int (make-integers-generator i0))
     (make-generator-procedure
      (lambda ()
        (let loop ()
          (suspend (expt (next-int) n))
          (loop)))))
    ((n)
     (make-nth-powers-generator n 0))))

(define (make-filter-generator gen1 gen2)
  (make-generator-procedure
   (lambda ()
     (let loop ((x1 (gen1))
                (x2 (gen2)))
       (cond ((= x1 x2) (loop (gen1) x2)) ; Skip this x1.
             ((< x1 x2) (begin            ; Return this x1.
                          (suspend x1)
                          (loop (gen1) x2)))
             (else (loop x1 (gen2))))))))

(define (gen-drop n)
  (lambda (generator)
    (make-generator-procedure
     (lambda ()
       (do ((i 0 (+ i 1)))
           ((= i n))
         (generator))
       (let loop ()
         (suspend (generator))
         (loop))))))

(define (gen-take n)
  (lambda (generator)
    (make-generator-procedure
     (lambda ()
       (do ((i 0 (+ i 1)))
           ((= i n))
         (suspend (generator)))
       (let loop ()
         (suspend #f)
         (loop))))))

(define my-generator
  ((gen-take 10)
   ((gen-drop 20)
    (make-filter-generator
     (make-nth-powers-generator 2)
     (make-nth-powers-generator 3)))))

(let loop ()
  (let ((x (my-generator)))
    (when x
      (display " ")
      (display x)
      (loop))))
(newline)
