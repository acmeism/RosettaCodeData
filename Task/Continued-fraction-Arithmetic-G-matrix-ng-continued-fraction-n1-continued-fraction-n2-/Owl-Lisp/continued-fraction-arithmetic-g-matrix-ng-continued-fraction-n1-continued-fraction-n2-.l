;;--------------------------------------------------------------------
;;
;; A continued fraction will be represented as an infinite lazy list
;; of terms, where a term is either an integer or the symbol 'infinity
;;
;;--------------------------------------------------------------------

(define (cf2maxterms-string maxterms cf)
  (let repeat ((p cf)
               (i 0)
               (s "["))
    (let ((term (lcar p))
          (rest (lcdr p)))
      (if (eq? term 'infinity)
          (string-append s "]")
          (if (>= i maxterms)
              (string-append s ",...]")
              (let ((separator (case i
                                 ((0) "")
                                 ((1) ";")
                                 (else ",")))
                    (term-str (number->string term)))
                (repeat rest (+ i 1)
                        (string-append s separator term-str))))))))

(define (cf2string cf)
  (cf2maxterms-string 20 cf))

;;--------------------------------------------------------------------

(define (repeated-term-cf term)
  (lunfold (lambda (x) (values x x))
           term
           (lambda (x) #false)))

(define cf-end (repeated-term-cf 'infinity))

(define (i2cf term) (pair term cf-end))

(define (r2cf fraction)
  ;; The entire finite-length continued fraction is constructed in
  ;; reverse order. The list is then rebuilt in the correct order, and
  ;; given an infinite number of 'infinity terms as its tail.
  (let repeat ((n (numerator fraction))
               (d (denominator fraction))
               (revlst #null))
    (if (zero? d)
        (lappend (reverse revlst) cf-end)
        (let-values (((q r) (truncate/ n d)))
          (repeat d r (cons q revlst))))))

(define (->cf x)
  (cond ((integer? x) (i2cf x))
        ((rational? x) (r2cf x))
        (else x)))

;;--------------------------------------------------------------------

(define (maybe-divide a b)
  (if (zero? b)
      (values #false #false)
      (truncate/ a b)))

(define integer-exceeds-processing-threshold?
  (let ((threshold+1 (expt 2 512)))
    (lambda (i) (>= (abs i) threshold+1))))

(define (any-exceed-processing-threshold? lst)
  (any integer-exceeds-processing-threshold? lst))

(define integer-exceeds-infinitizing-threshold?
  (let ((threshold+1 (expt 2 64)))
    (lambda (i) (>= (abs i) threshold+1))))

(define (ng8-values ng)
  (values (list-ref ng 0)
          (list-ref ng 1)
          (list-ref ng 2)
          (list-ref ng 3)
          (list-ref ng 4)
          (list-ref ng 5)
          (list-ref ng 6)
          (list-ref ng 7)))

(define (absorb-x-term ng x y)
  (let-values (((a12 a1 a2 a b12 b1 b2 b) (ng8-values ng)))
    (define (no-more-x)
      (values (list a12 a1 a12 a1 b12 b1 b12 b1) cf-end y))
    (let ((term (lcar x)))
      (if (eq? term 'infinity)
          (no-more-x)
          (let ((new-ng (list (+ a2 (* a12 term))
                              (+ a  (* a1  term)) a12 a1
                              (+ b2 (* b12 term))
                              (+ b  (* b1  term)) b12 b1)))
            (cond ((any-exceed-processing-threshold? new-ng)
                   ;; Pretend we have reached the end of x.
                   (no-more-x))
                  (else (values new-ng (lcdr x) y))))))))

(define (absorb-y-term ng x y)
  (let-values (((a12 a1 a2 a b12 b1 b2 b) (ng8-values ng)))
    (define (no-more-y)
      (values (list a12 a12 a2 a2 b12 b12 b2 b2) x cf-end))
    (let ((term (lcar y)))
      (if (eq? term 'infinity)
          (no-more-y)
          (let ((new-ng (list (+ a1 (* a12 term)) a12
                              (+ a  (* a2  term)) a2
                              (+ b1 (* b12 term)) b12
                              (+ b  (* b2  term)) b2)))
            (cond ((any-exceed-processing-threshold? new-ng)
                   ;; Pretend we have reached the end of y.
                   (no-more-y))
                  (else (values new-ng x (lcdr y)))))))))

(define (apply-ng8 ng x y)
  (let repeat ((ng ng)
               (x (->cf x))
               (y (->cf y)))
    (let-values (((a12 a1 a2 a b12 b1 b2 b) (ng8-values ng)))
      (cond ((every zero? (list b12 b1 b2 b)) cf-end)
            ((every zero? (list b2 b))
             (let-values (((ng x y) (absorb-x-term ng x y)))
               (repeat ng x y)))
            ((any zero? (list b2 b))
             (let-values (((ng x y) (absorb-y-term ng x y)))
               (repeat ng x y)))
            ((zero? b1)
             (let-values (((ng x y) (absorb-x-term ng x y)))
               (repeat ng x y)))
            (else
             (let-values (((q12 r12) (maybe-divide a12 b12))
                          ((q1 r1) (maybe-divide a1 b1))
                          ((q2 r2) (maybe-divide a2 b2))
                          ((q r) (maybe-divide a b)))
               (cond
                ((and (not (zero? b12))
                      (= q q12) (= q q1) (= q q2))
                 ;; Output a term.
                 (if (integer-exceeds-infinitizing-threshold? q)
                     cf-end            ; Pretend the term is infinite.
                     (let ((new-ng (list b12 b1 b2 b r12 r1 r2 r)))
                       (pair q (repeat new-ng x y)))))
                (else
                 ;; Put a1, a2, and a over a common denominator
                 ;; and compare some magnitudes.
                 (let ((n1 (* a1 b2 b))
                       (n2 (* a2 b1 b))
                       (n  (* a  b1 b2)))
                   (let ((absorb-term
                          (if (> (abs (- n1 n)) (abs (- n2 n)))
                              absorb-x-term
                              absorb-y-term)))
                     (let-values (((ng x y) (absorb-term ng x y)))
                       (repeat ng x y))))))))))))

;;--------------------------------------------------------------------

(define (make-ng8-operation ng) (lambda (x y) (apply-ng8 ng x y)))

(define cf+ (make-ng8-operation '(0 1 1 0 0 0 0 1)))
(define cf- (make-ng8-operation '(0 1 -1 0 0 0 0 1)))
(define cf* (make-ng8-operation '(1 0 0 0 0 0 0 1)))
(define cf/ (make-ng8-operation '(0 1 0 0 0 0 1 0)))

;;--------------------------------------------------------------------

(define golden-ratio (repeated-term-cf 1))
(define silver-ratio (repeated-term-cf 2))
(define sqrt2 (pair 1 silver-ratio))
(define sqrt5 (pair 2 (repeated-term-cf 4)))

;;--------------------------------------------------------------------

(define (show expression cf note)
  (let* ((cf (cf2string cf))
         (expr-len (string-length expression))
         (expr-pad-len (max 0 (- 18 expr-len)))
         (expr-pad (make-string expr-pad-len #\space)))
    (display expr-pad)
    (display expression)
    (display " =>  ")
    (display cf)
    (unless (string=? note "")
      (let* ((cf-len (string-length cf))
             (cf-pad-len (max 0 (- 48 cf-len)))
             (cf-pad (make-string cf-pad-len #\space)))
        (display cf-pad)
        (display note)))
    (newline)))

(show "13/11 + 1/2" (cf+ 13/11 1/2) "(cf+ 13/11 1/2)")
(show "22/7 + 1/2" (cf+ 22/7 1/2) "(cf+ 22/7 1/2)")
(show "22/7 * 1/2" (cf* 22/7 1/2) "(cf* 22/7 1/2)")
(show "golden ratio" golden-ratio "(repeated-term-cf 1)")
(show "silver ratio" silver-ratio "(repeated-term-cf 2)")
(show "sqrt(2)" sqrt2 "(pair 1 silver-ratio)")
(show "sqrt(2)" (cf- silver-ratio 1) "(cf- silver-ratio 1)")
(show "sqrt(5)" sqrt5 "(pair 2 (repeated-term-cf 4)")
(show "sqrt(5)" (cf- (cf* 2 golden-ratio) 1)
      "(cf- (cf* 2 golden-ratio) 1)")
(show "sqrt(2) + sqrt(2)" (cf+ sqrt2 sqrt2) "(cf+ sqrt2 sqrt2)")
(show "sqrt(2) - sqrt(2)" (cf- sqrt2 sqrt2) "(cf- sqrt2 sqrt2)")
(show "sqrt(2) * sqrt(2)" (cf* sqrt2 sqrt2) "(cf* sqrt2 sqrt2)")
(show "sqrt(2) / sqrt(2)" (cf/ sqrt2 sqrt2) "(cf/ sqrt2 sqrt2)")
(show "(1 + 1/sqrt(2))/2" (cf/ (cf+ 1 (cf/ 1 sqrt2)) 2)
      "(cf/ (cf+ 1 (cf/ 1 sqrt2)) 2)")
(show "(1 + 1/sqrt(2))/2" (apply-ng8 '(0 1 0 0 0 0 2 0)
                                     silver-ratio sqrt2)
      "(apply-ng8 '(0 1 0 0 0 0 2 0) sqrt2 sqrt2)")
(show "(1 + 1/sqrt(2))/2" (apply-ng8 '(1 0 0 1 0 0 0 8)
                                     silver-ratio silver-ratio)
      "(apply-ng8 '(1 0 0 1 0 0 0 8) silver-ratio silver-ratio)")

;;--------------------------------------------------------------------
