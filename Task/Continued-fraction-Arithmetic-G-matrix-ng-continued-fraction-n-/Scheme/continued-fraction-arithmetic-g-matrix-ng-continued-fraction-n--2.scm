(cond-expand
  (r7rs)
  (chicken (import (r7rs))))

(define-library (continued-fraction)

  (export make-continued-fraction
          continued-fraction?
          continued-fraction-ref
          continued-fraction->thunk)
  (export continued-fraction->string
          continued-fraction-max-terms)

  (import (scheme base)
          (scheme case-lambda))

  (begin

    (define-record-type <cf-record>
      ;; terminated? -- are these all the terms there are?
      ;; m           -- how many terms are memoized so far?
      ;; memo        -- where terms are memoized.
      ;; gen         -- a thunk that generates terms.
      (cf-record terminated? m memo gen)
      cf-record?
      (terminated? cf-record-terminated?
                   set-cf-record-terminated?!)
      (m cf-record-m set-cf-record-m!)
      (memo cf-record-memo set-cf-record-memo!)
      (gen cf-record-gen set-cf-record-gen!))

    (define cf-record-memo-start-size 8)

    (define (make-continued-fraction gen)
      (cf-record #f 0 (make-vector cf-record-memo-start-size) gen))

    (define continued-fraction? cf-record?)

    ;; The following is an updating operation, but nevertheless I
    ;; leave out the "!" from the name.
    (define (continued-fraction-ref cf i)
      (cf-update! cf (+ i 1))
      (and (< i (cf-record-m cf))
           (vector-ref (cf-record-memo cf) i)))

    (define (cf-get-more-terms! cf needed)
      (define (loop i)
        (if (= i needed)
            (begin
              (set-cf-record-terminated?! cf #f)
              (set-cf-record-m! cf needed))
            (let ((term ((cf-record-gen cf))))
              (if term
                  (begin
                    (vector-set! (cf-record-memo cf) i term)
                    (loop (+ i 1)))
                  (begin
                    (set-cf-record-terminated?! cf #t)
                    (set-cf-record-m! cf i))))))
      (loop (cf-record-m cf)))

    (define (cf-update! cf needed)
      (cond ((cf-record-terminated? cf) (begin))
            ((<= needed (cf-record-m cf)) (begin))
            ((<= needed (vector-length (cf-record-memo cf)))
             (cf-get-more-terms! cf needed))
            (else
             ;; Provide twice the room that might be needed.
             (let* ((n1 (+ needed needed))
                    (memo1 (make-vector n1)))
               (vector-copy! memo1 0 (cf-record-memo cf))
               (set-cf-record-memo! cf memo1)
               (cf-get-more-terms! cf needed)))))

    (define (continued-fraction->thunk cf)
      ;; Make a generator from a continued fraction.
      (define i 0)
      (lambda ()
        (let ((term (continued-fraction-ref cf i)))
          (set! i (+ i 1))
          term)))

    (define continued-fraction-max-terms (make-parameter 20))

    ;; The following is an updating operation, but nevertheless I
    ;; leave out the "!" from the name.
    (define continued-fraction->string
      (case-lambda
        ((cf) (continued-fraction->string
               cf (continued-fraction-max-terms)))
        ((cf max-terms)
         (let loop ((i 0)
                    (sep 0)
                    (accum "["))
           (if (= i max-terms)
               (string-append accum ",...]")
               (let ((term (continued-fraction-ref cf i)))
                 (if (not term)
                     (string-append accum "]")
                     (let* ((term-str (number->string term))
                            (sep-str (case sep
                                       ((0) "")
                                       ((1) ";")
                                       ((2) ",")))
                            (accum (string-append accum sep-str
                                                  term-str))
                            (sep (min (+ sep 1) 2)))
                       (loop (+ i 1) sep accum)))))))))

    )) ;; end library (continued-fraction)

(define-library (number->continued-fraction)

  (export number->continued-fraction)

  (import (scheme base))
  (import (continued-fraction))

  (begin

    (define (number->continued-fraction x)
      ;; This algorithm works directly with exact rationals, rather
      ;; than numerator and denominator separately.
      (unless (real? x)
        (error "number->continued-fraction: argument must be real" x))
      (let ((ratnum (exact x))
            (terminated? #f))
        (make-continued-fraction
         (lambda ()
           (and (not terminated?)
                (let* ((q (floor ratnum))
                       (diff (- ratnum q)))
                  (if (zero? diff)
                      (set! terminated? #t)
                      (set! ratnum (/ diff)))
                  q))))))

    )) ;; end library (number->continued-fraction)

(define-library (homographic-function)

  (export make-homographic-function
          homographic-function?
          homographic-function-ref
          homographic-function-set!
          homographic-function-copy
          apply-homographic-function
          make-homographic-function-operator)

  (import (scheme base)
          (scheme case-lambda))
  (import (continued-fraction))

  (begin

    (define-record-type <homographic-function>
      (make-homographic-function a1 a b1 b)
      homographic-function?
      (a1 homographic-function-a1 set-homographic-function-a1!)
      (a homographic-function-a set-homographic-function-a!)
      (b1 homographic-function-b1 set-homographic-function-b1!)
      (b homographic-function-b set-homographic-function-b!))

    (define (homographic-function-ref hfunc i)
      (case i
        ((0) (homographic-function-a1 hfunc))
        ((1) (homographic-function-a hfunc))
        ((2) (homographic-function-b1 hfunc))
        ((3) (homographic-function-b hfunc))
        (else
         (error "homographic-function-ref: index out of range" i))))

    (define (homographic-function-set! hfunc i x)
      (case i
        ((0) (set-homographic-function-a1! hfunc x))
        ((1) (set-homographic-function-a! hfunc x))
        ((2) (set-homographic-function-b1! hfunc x))
        ((3) (set-homographic-function-b! hfunc x))
        (else
         (error "homographic-function-set!: index out of range" i))))

    (define (homographic-function-copy hfunc)
      (make-homographic-function (homographic-function-ref hfunc 0)
                                 (homographic-function-ref hfunc 1)
                                 (homographic-function-ref hfunc 2)
                                 (homographic-function-ref hfunc 3)))

    (define (apply-homographic-function hfunc cf)
      (define gen (continued-fraction->thunk cf))
      (define state (homographic-function-copy hfunc))
      (make-continued-fraction
       (lambda ()
         (let loop ()
           (let ((a1 (homographic-function-ref state 0))
                 (a (homographic-function-ref state 1))
                 (b1 (homographic-function-ref state 2))
                 (b (homographic-function-ref state 3)))
             (define (take-term)
               (let ((term (gen)))
                 (if term
                     (set! state
                       (make-homographic-function
                        (+ a (* a1 term)) a1 (+ b (* b1 term)) b1))
                     (begin
                       (homographic-function-set! state 1 a1)
                       (homographic-function-set! state 3 b1)))))
             (cond
              ((and (zero? b1) (zero? b)) #f)
              ((and (not (zero? b1)) (not (zero? b)))
               (let ((q1 (floor-quotient a1 b1))
                     (q (floor-quotient a b)))
                 (if (= q1 q)
                     (begin
                       (set! state
                         (make-homographic-function
                          b1 b (- a1 (* b1 q)) (- a (* b q))))
                       q)
                     (begin
                       (take-term)
                       (loop)))))
              (else
               (take-term)
               (loop))))))))

    (define make-homographic-function-operator
      (case-lambda
        ((hfunc) (lambda (cf)
                   (apply-homographic-function hfunc cf)))
        ((a1 a b1 b) (make-homographic-function-operator
                      (make-homographic-function a1 a b1 b)))))

    )) ;; end library (number->continued-fraction)

(define-library (demonstration)

  (export run-demonstration)

  (import (scheme base)
          (scheme write))
  (import (continued-fraction)
          (number->continued-fraction)
          (homographic-function))

  (begin

    (define (run-demonstration)

      (define cf+1/2 (make-homographic-function-operator 2 1 0 2))
      (define cf/2 (make-homographic-function-operator 1 0 0 2))
      (define cf/4 (make-homographic-function-operator 1 0 0 4))
      (define 1/cf (make-homographic-function-operator 0 1 1 0))
      (define 2+cf./4 (make-homographic-function-operator 1 2 0 4))
      (define 1+cf./2 (make-homographic-function-operator 1 1 0 2))

      (define cf:13/11 (number->continued-fraction 13/11))
      (define cf:22/7 (number->continued-fraction 22/7))
      (define cf:sqrt2
        (let ((next-term 1))
          (make-continued-fraction
           (lambda ()
             (let ((term next-term))
               (set! next-term 2)
               term)))))

      (display-cf "13/11" cf:13/11)
      (display-cf "22/7" cf:22/7)
      (display-cf "sqrt(2)" cf:sqrt2)
      (display-cf "13/11 + 1/2" (cf+1/2 cf:13/11))
      (display-cf "22/7 + 1/2" (cf+1/2 cf:22/7))
      (display-cf "(22/7)/4" (cf/4 cf:22/7))
      (display-cf "sqrt(2)/2" (cf/2 cf:sqrt2))
      (display-cf "1/sqrt(2)" (1/cf cf:sqrt2))
      (display-cf "(2 + sqrt(2))/4" (2+cf./4 cf:sqrt2))
      (display-cf "(1 + 1/sqrt(2))/2" (1+cf./2 (1/cf cf:sqrt2)))
      (display-cf "sqrt(2)/4 + 1/2" (cf+1/2 (cf/4 cf:sqrt2)))
      (display-cf "(sqrt(2)/2)/2 + 1/2" (cf+1/2 (cf/2 (cf/2 cf:sqrt2))))
      (display-cf "(1/sqrt(2))/2 + 1/2" (cf+1/2 (cf/2 (1/cf cf:sqrt2)))))

    (define (display-cf expr cf)
      (display expr)
      (display " => ")
      (display (continued-fraction->string cf))
      (newline))

    )) ;; end library (demonstration)

(import (demonstration))
(run-demonstration)
