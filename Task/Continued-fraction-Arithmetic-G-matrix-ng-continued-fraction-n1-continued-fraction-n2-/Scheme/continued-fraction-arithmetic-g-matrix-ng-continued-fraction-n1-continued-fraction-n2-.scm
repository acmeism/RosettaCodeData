(cond-expand
  (r7rs)
  (chicken (import (r7rs))))

;;;-------------------------------------------------------------------

(define-library (cf)

  (export make-cf
          cf?
          *cf-max-terms*
          cf->string
          number->cf
          ng8->procedure)

  (import (scheme base)
          (scheme case-lambda))

  (begin

    (define-record-type <cf>
      (%%make-cf terminated? ;; No more terms?
                 m           ;; No. of terms memoized.
                 memo        ;; Memoized terms.
                 gen)        ;; Term-generating thunk.
      cf?
      (terminated? cf-terminated? set-cf-terminated?!)
      (m cf-m set-cf-m!)
      (memo cf-memo set-cf-memo!)
      (gen cf-gen set-cf-gen!))

    (define (make-cf gen)             ; Make a new continued fraction.
      (%%make-cf #f 0 (make-vector 32) gen))

    (define (cf-ref cf i)  ; Get the ith term, or #f if there is none.
      (define (get-more-terms! needed)
        (do () ((or (cf-terminated? cf) (= (cf-m cf) needed)))
          (let ((term ((cf-gen cf))))
            (if term
                (begin
                  (vector-set! (cf-memo cf) (cf-m cf) term)
                  (set-cf-m! cf (+ (cf-m cf) 1)))
                (set-cf-terminated?! cf #t)))))
      (define (update! needed)
        (cond ((cf-terminated? cf) (begin))
              ((<= needed (cf-m cf)) (begin))
              ((<= needed (vector-length (cf-memo cf)))
               (get-more-terms! needed))
              (else ;; Increase the storage space for memoization.
               (let* ((n1 (+ needed needed))
                      (memo1 (make-vector n1)))
                 (vector-copy! memo1 0 (cf-memo cf) 0 (cf-m cf))
                 (set-cf-memo! cf memo1))
               (get-more-terms! needed))))
      (update! (+ i 1))
      (and (< i (cf-m cf))
           (vector-ref (cf-memo cf) i)))

    (define *cf-max-terms*  ; Default term-count limit for cf->string.
      (make-parameter 20))

    (define cf->string       ; Make a string for a continued fraction.
      (case-lambda
        ((cf) (cf->string cf (*cf-max-terms*)))
        ((cf max-terms)
         (let loop ((i 0)
                    (s "["))
           (let ((term (cf-ref cf i)))
             (cond ((not term) (string-append s "]"))
                   ((= i max-terms) (string-append s ",...]"))
                   (else
                    (let ((separator (case i
                                       ((0) "")
                                       ((1) ";")
                                       (else ",")))
                          (term-str (number->string term)))
                      (loop (+ i 1) (string-append s separator
                                                   term-str))))))))))

    (define (number->cf num) ; Convert a number to a continued fraction.
      (let ((num (exact num)))
        (let ((n (numerator num))
              (d (denominator num)))
          (make-cf
           (lambda ()
             (and (not (zero? d))
                  (let-values (((q r) (floor/ n d)))
                    (set! n d)
                    (set! d r)
                    q)))))))

    (define (%%divide a b)
      (if (zero? b)
          (values #f #f)
          (floor/ a b)))

    (define (ng8->procedure ng8)

      ;; Thresholds chosen merely for demonstration.
      (define number-that-is-too-big (expt 2 512))
      (define practically-infinite (expt 2 64))

      (define too-big?  ; Stop computing if a no. reaches a threshold.
        (lambda (values)
          (cond ((null? values) #f)
                ((>= (abs (car values))
                     (abs number-that-is-too-big)) #t)
                (else (too-big? (cdr values))))))

      (define (treat-as-infinite? term)
        (>= (abs term) (abs practically-infinite)))

      (lambda (x y)

        (define (make-source cf)
          (let ((i 0))
            (lambda ()
              (let ((term (cf-ref cf i)))
                (set! i (+ i 1))
                term))))

        (define no-terms-source (lambda () #f))

        (define ng ng8)
        (define xsource (make-source x))
        (define ysource (make-source y))

        ;; The procedures "main", "compare-quotients",
        ;; "absorb-x-term", and "absorb-y-term" form a mutually
        ;; tail-recursive set. In standard Scheme, such an arrangement
        ;; requires no special notations, and WILL NOT blow up the
        ;; stack.

        (define (main)          ; "main" is the term-generating thunk.
          (define-values (a12 a1 a2 a b12 b1 b2 b)
            (apply values ng))
          (define bz? (zero? b))
          (define b1z? (zero? b1))
          (define b2z? (zero? b2))
          (define b12z? (zero? b12))
          (cond
           ((and bz? b1z? b2z? b12z?) #f)
           ((and bz? b2z?) (absorb-x-term))
           ((or bz? b2z?) (absorb-y-term))
           (b1z? (absorb-x-term))
           (else
            (let-values (((q  r)  (%%divide a b))
                         ((q1 r1) (%%divide a1 b1))
                         ((q2 r2) (%%divide a2 b2))
                         ((q12 r12) (%%divide a12 b12)))
              (if (and (not b12z?) (= q q1 q2 q12))
                  (output-a-term q b12 b1 b2 b r12 r1 r2 r)
                  (compare-quotients a2 a1 a b2 b1 b))))))

        (define (compare-quotients a2 a1 a b2 b1 b)
          (let ((n (* a b1 b2))
                (n1 (* a1 b b2))
                (n2 (* a2 b b1)))
            (if (> (abs (- n1 n)) (abs (- n2 n)))
                (absorb-x-term)
                (absorb-y-term))))

        (define (absorb-x-term)
          (define-values (a12 a1 a2 a b12 b1 b2 b)
            (apply values ng))
          (define term (xsource))
          (if term
              (let ((new-ng (list (+ a2 (* a12 term))
                                  (+ a  (* a1  term))
                                  a12 a1
                                  (+ b2 (* b12 term))
                                  (+ b  (* b1  term))
                                  b12 b1)))
                (if (not (too-big? new-ng))
                    (set! ng new-ng)
                    (begin
                      ;; Replace the x source with one that returns no
                      ;; terms.
                      (set! xsource no-terms-source)
                      (set! ng (list a12 a1 a12 a1 b12 b1 b12 b1)))))
              (set! ng (list a12 a1 a12 a1 b12 b1 b12 b1)))
          (main))

        (define (absorb-y-term)
          (define-values (a12 a1 a2 a b12 b1 b2 b)
            (apply values ng))
          (define term (ysource))
          (if term
              (let ((new-ng (list (+ a1 (* a12 term)) a12
                                  (+ a  (* a2  term)) a2
                                  (+ b1 (* b12 term)) b12
                                  (+ b  (* b2  term)) b2)))
                (if (not (too-big? new-ng))
                    (set! ng new-ng)
                    (begin
                      ;; Replace the y source with one that returns no
                      ;; terms.
                      (set! ysource no-terms-source)
                      (set! ng (list a12 a12 a2 a2 b12 b12 b2 b2)))))
              (set! ng (list a12 a12 a2 a2 b12 b12 b2 b2)))
          (main))

        (define (output-a-term q b12 b1 b2 b r12 r1 r2 r)
          (let ((new-ng (list b12 b1 b2 b r12 r1 r2 r))
                (term (and (not (treat-as-infinite? q)) q)))
            (set! ng new-ng)
            term))

        (make-cf main))) ;; end procedure ng8->procedure

    )) ;; end library (cf)

;;;-------------------------------------------------------------------

(import (scheme base))
(import (scheme case-lambda))
(import (scheme write))
(import (cf))

(define golden-ratio (make-cf (lambda () 1)))
(define silver-ratio (make-cf (lambda () 2)))
(define sqrt2 (make-cf (let ((next-term 1))
                         (lambda ()
                           (let ((term next-term))
                             (set! next-term 2)
                             term)))))
(define frac13/11 (number->cf 13/11))
(define frac22/7 (number->cf 22/7))
(define one (number->cf 1))
(define two (number->cf 2))
(define three (number->cf 3))
(define four (number->cf 4))

(define cf+ (ng8->procedure '(0 1 1 0 0 0 0 1)))
(define cf- (ng8->procedure '(0 1 -1 0 0 0 0 1)))
(define cf* (ng8->procedure '(1 0 0 0 0 0 0 1)))
(define cf/ (ng8->procedure '(0 1 0 0 0 0 1 0)))

(define show
  (case-lambda
    ((expression cf note)
     (display expression)
     (display " =>  ")
     (display (cf->string cf))
     (display note)
     (newline))
    ((expression cf)
     (show expression cf ""))))

(show "      golden ratio" golden-ratio)
(show "      silver ratio" silver-ratio)
(show "           sqrt(2)" sqrt2)
(show "             13/11" frac13/11)
(show "              22/7" frac22/7)
(show "                 1" one)
(show "                 2" two)
(show "                 3" three)
(show "                 4" four)
(show " (1 + 1/sqrt(2))/2" (cf/ (cf+ one (cf/ one sqrt2)) two)
      "  method 1")
(show " (1 + 1/sqrt(2))/2" ((ng8->procedure '(1 0 0 1 0 0 0 8))
                            silver-ratio silver-ratio)
      "  method 2")
(show " (1 + 1/sqrt(2))/2" (cf/ (cf/ (cf/ silver-ratio sqrt2)
                                     sqrt2)
                                sqrt2)
      "  method 3")
(show " sqrt(2) + sqrt(2)" (cf+ sqrt2 sqrt2))
(show " sqrt(2) - sqrt(2)" (cf- sqrt2 sqrt2))
(show " sqrt(2) * sqrt(2)" (cf* sqrt2 sqrt2))
(show " sqrt(2) / sqrt(2)" (cf/ sqrt2 sqrt2))

;;;-------------------------------------------------------------------
