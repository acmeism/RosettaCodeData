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

; Enforce the length of the given continued fraction list to be odd.
; Changes the list in situ (if needed), and returns its possibly changed value.
(define continued-fraction-list-enforce-odd-length!
  (lambda (cf)
    (when (even? (length cf))
      (let ((cf-last-cons (list-tail cf (1- (length cf)))))
        (set-car! cf-last-cons (1- (car cf-last-cons)))
        (set-cdr! cf-last-cons (cons 1 '()))))
    cf))
