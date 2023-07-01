(cond-expand
  (r7rs)
  (chicken (import (r7rs))))

(import (scheme base))
(import (scheme case-lambda))
(import (scheme write))
(import (srfi 41))

;;;-------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; The entirety of r2cf, two different ways ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; r2cf-VERSION1 works with integers. (Any floating-point number is
;; first converted to exact rational.)
(define (r2cf-VERSION1 fraction)
  (define-stream (recurs n d)
    (if (zero? d)
        stream-null
        (let-values (((q r) (floor/ n d)))
          (stream-cons q (recurs d r)))))
  (let ((fraction (exact fraction)))
    (recurs (numerator fraction) (denominator fraction))))

;; r2cf-VERSION2 works directly with fractions. (Any floating-point
;; number is first converted to exact rational.)
(define (r2cf-VERSION2 fraction)
  (define-stream (recurs fraction)
    (let* ((quotient (floor fraction))
           (remainder (- fraction quotient)))
      (stream-cons quotient (if (zero? remainder)
                                stream-null
                                (recurs (/ remainder))))))
  (recurs (exact fraction)))

;;(define r2cf r2cf-VERSION1)
(define r2cf r2cf-VERSION2)

;;;-------------------------------------------------------------------

(define *max-terms* (make-parameter 20))

(define cf2string
  (case-lambda
    ((cf) (cf2string cf (*max-terms*)))
    ((cf max-terms)
     (let loop ((i 0)
                (s "[")
                (strm cf))
       (if (stream-null? strm)
           (string-append s "]")
           (let ((term (stream-car strm))
                 (tail (stream-cdr strm)))
             (if (= i max-terms)
                 (string-append s ",...]")
                 (let ((separator (case i
                                    ((0) "")
                                    ((1) ";")
                                    (else ",")))
                       (term-str (number->string term)))
                   (loop (+ i 1)
                         (string-append s separator term-str)
                         tail)))))))))

(define (show fraction)
  (parameterize ((*max-terms* 1000))
    (display fraction)
    (display " => ")
    (display (cf2string (r2cf fraction)))
    (newline)))

(show 1/2)
(show 3)
(show 23/8)
(show 13/11)
(show 22/11)
(show -151/77)
(show 14142/10000)
(show 141421/100000)
(show 1414214/1000000)
(show 14142136/10000000)
(show 1414213562373095049/1000000000000000000)

;; Decimal expansion of sqrt(2): see https://oeis.org/A002193
(show 141421356237309504880168872420969807856967187537694807317667973799073247846210703885038753432764157/100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)

(show 31/10)
(show 314/100)
(show 3142/1000)
(show 31428/10000)
(show 314285/100000)
(show 3142857/1000000)
(show 31428571/10000000)
(show 314285714/100000000)
(show 3142857142857143/1000000000000000)

;; Decimal expansion of pi: see https://oeis.org/A000796
(show 314159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214/100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)
