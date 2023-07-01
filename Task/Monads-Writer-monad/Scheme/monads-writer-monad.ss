(define-library (monad base)
  (export make-monad monad? monad-identifier
          monad-object monad-additional
          >>= >=>)
  (import (scheme base)
          (scheme case-lambda))
  (begin

    (define-record-type <monad>
      (make-monad identifier bind object additional)
      monad?
      (identifier monad-identifier)
      (bind monad-bind)
      (object monad-object)
      (additional monad-additional))

    (define >>=
      (case-lambda
        ((m f) ((monad-bind m) m f))
        ((m f . g*) (apply >>= (cons (>>= m f) g*)))))

    (define >=>
      (case-lambda
        ((f g) (lambda (x) (>>= (f x) g)))
        ((f g . h*) (apply >=> (cons (>=> f g) h*)))))

    )) ;; end library

(define-library (monad perform)
  (export perform)
  (import (scheme base)
          (monad base))
  (begin

    (define-syntax perform
      ;; "do" is already one of the loop syntaxes, so I call this
      ;; syntax "perform" instead.
      (syntax-rules (<-)
        ((perform (x <- action) clause clause* ...)
         (>>= action (lambda (x) (perform clause clause* ...))))
        ((perform action)
         action)
        ((perform action clause clause* ...)
         (action (perform clause clause* ...)))))

    )) ;; end library

(define-library (monad writer-monad)
  (export make-writer-monad writer-monad?)
  (import (scheme base)
          (monad base))
  (begin

    ;; The messages are a list, most recent message first, of whatever
    ;; data f decides to log.
    (define (make-writer-monad object messages)
      (define (bind m f)
        (let ((ym (f (monad-object m))))
          (let ((old-messages (monad-additional m))
                (new-messages (monad-additional ym))
                (y (monad-object ym)))
            (make-monad 'writer-monad bind y
                        (append new-messages old-messages)))))
      (unless (or (null? messages) (pair? messages))
        ;;
        ;; I do not actually test whether the list is proper, because
        ;; to do so would be inefficient.
        ;;
        ;; The R7RS-small test for properness of a list is called
        ;; "list?" (and the report says something tendentious in
        ;; defense of this name, but really it is simply historical
        ;; usage). The SRFI-1 procedure, by constrast, is called
        ;; "proper-list?".
        ;;
        (error "should be a proper list" messages))
      (make-monad 'writer-monad bind object messages))

    (define (writer-monad? object)
      (and (monad? object)
           (eq? (monad-identifier object) 'writer-monad)))

    )) ;; end library

(import (scheme base)
        (scheme inexact)
        (scheme write)
        (monad base)
        (monad perform)
        (monad writer-monad))

(define root sqrt)
(define (addOne x) (+ x 1))
(define (half x) (/ x 2))

(define-syntax make-logging
  (syntax-rules ()
    ((_ proc)
     (lambda (x)
       (define (make-msg x y) (list x 'proc y))
       (let ((y (proc x)))
         (make-writer-monad y (list (make-msg x y))))))))

(define logging-root (make-logging root))
(define logging-addOne (make-logging addOne))
(define logging-half (make-logging half))

(define (display-messages messages)
  (if (writer-monad? messages)
      (display-messages (monad-additional messages))
      (begin
        (display "  messages:")
        (newline)
        (let loop ((lst (reverse messages)))
          (when (pair? lst)
            (display "    ")
            (write (car lst))
            (newline)
            (loop (cdr lst)))))))

(display "---------------") (newline)
(display "Using just >>=") (newline)
(display "---------------") (newline)
(define result
  (>>= (make-writer-monad 5 '((new writer-monad 5)))
       logging-root logging-addOne logging-half))
(display "  (1 + sqrt(5))/2 = ")
(write (monad-object result)) (newline)
(display-messages result)

(newline)

(display "------------------") (newline)
(display "Using >>= and >=>") (newline)
(display "------------------") (newline)
(define result
  (>>= (make-writer-monad 5 '((new writer-monad 5)))
       (>=> logging-root logging-addOne logging-half)))
(display "  (1 + sqrt(5))/2 = ")
(write (monad-object result)) (newline)
(display-messages result)

(newline)

(display "-----------------------") (newline)
(display "Using 'perform' syntax") (newline)
(display "-----------------------") (newline)
(define result
  (perform (x <- (make-writer-monad 5 '((new writer-monad 5))))
           (x <- (logging-root x))
           (x <- (logging-addOne x))
           (logging-half x)))
(display "  (1 + sqrt(5))/2 = ")
(write (monad-object result)) (newline)
(display-messages result)
