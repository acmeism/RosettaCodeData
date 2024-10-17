; Return list of the Repunit Primes in the given base up to the given limit.
(define repunit_primes
  (lambda (base limit)
    (let loop ((count 2)
               (value (1+ base)))
      (cond ((> count limit)
              '())
            ((and (prime<probably>? count) (prime<probably>? value))
              (cons count (loop (1+ count) (+ value (expt base count)))))
            (else
              (loop (1+ count) (+ value (expt base count))))))))

; Show all the Repunit Primes up to 2700 digits for bases 2 through 16.
(let ((max-base 16)
      (max-digits 2700))
  (printf "~%Repunit Primes up to ~d digits for bases 2 through ~d:~%" max-digits max-base)
  (do ((base 2 (1+ base)))
      ((> base max-base))
    (printf "Base ~2d: ~a~%" base (repunit_primes base max-digits))))
