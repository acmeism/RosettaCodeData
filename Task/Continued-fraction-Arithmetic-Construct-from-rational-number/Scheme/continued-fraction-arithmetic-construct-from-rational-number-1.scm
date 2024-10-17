; Create a terminating Continued Fraction generator for the given rational number.
; Returns one term per call; returns #f when no more terms remaining.
(define make-continued-fraction-gen
  (lambda (rat)
    (let ((num (numerator rat)) (den (denominator rat)))
      (lambda ()
        (if (= den 0)
          #f
          (let ((ret (quotient num den))
                (rem (modulo num den)))
            (set! num den)
            (set! den rem)
            ret))))))

; Return the continued fraction representation of a rational number as a string.
(define rat->cf-string
  (lambda (rat)
    (let* ((cf (make-continued-fraction-gen rat))
           (str (string-append "[" (format "~a" (cf))))
           (sep ";"))
      (let loop ((term (cf)))
        (when term
          (set! str (string-append str (format "~a ~a" sep term)))
          (set! sep ",")
          (loop (cf))))
      (string-append str "]"))))

; Return the continued fraction representation of a rational number as a list of terms.
(define rat->cf-list
  (lambda (rat)
    (let ((cf (make-continued-fraction-gen rat))
          (lst '()))
      (let loop ((term (cf)))
        (when term
          (set! lst (append lst (list term)))
          (loop (cf))))
      lst)))
