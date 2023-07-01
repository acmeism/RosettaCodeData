(cond-expand
  (r7rs)
  (chicken (import (r7rs))))

(import (scheme base))
(import (scheme write))

;;;-------------------------------------------------------------------

(define (r2cf fraction consumer)
  (let* ((fraction (exact fraction)))
    (let loop ((n (numerator fraction))
               (d (denominator fraction))
               (consumer consumer))
      (if (zero? d)
          (call-with-current-continuation
           (lambda (kont) (consumer #f kont)))
          (let-values (((q r) (floor/ n d)))
            (loop d r (call-with-current-continuation
                       (lambda (kont) (consumer q kont)))))))))

(define (display-cf term producer)
  (display "[")
  (let loop ((term term)
             (producer producer)
             (separator ""))
    (if term
        (begin
          (display separator)
          (display term)
          (let-values (((term producer)
                        (call-with-current-continuation producer)))
            (loop term producer
                  (if (string=? separator "") ";" ","))))
        (begin
          (display "]")
          (call-with-current-continuation producer)))))

;;;-------------------------------------------------------------------

(define (show fraction)
  (display fraction)
  (display " => ")
  (r2cf fraction display-cf)
  (newline))

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
