; Show the first 15 Stern-Brocot sequence numbers.

(printf "First 15 Stern-Brocot numbers:")
(do ((index 1 (1+ index)))
    ((> index 15))
  (printf " ~a" (stern-brocot index)))
(newline)

; Show the indices of where the numbers 1 to 10 first appear in the Stern-Brocot sequence.

(let ((indices (make-vector 11 #f))
       (found 0))
  (do ((index 1 (1+ index)))
      ((>= found 10))
    (let ((number (stern-brocot index)))
      (when (and (<= number 10) (not (vector-ref indices number)))
        (vector-set! indices number index)
        (set! found (1+ found)))))
  (printf "Indices of where the numbers 1 to 10 first appear:")
  (do ((index 1 (1+ index)))
      ((> index 10))
  (printf " ~a" (vector-ref indices index))))
(newline)

; Show the index of where the number 100 first appears in the Stern-Brocot sequence.

(do ((index 1 (1+ index)) (found #f))
    (found)
  (let ((number (stern-brocot index)))
    (when (= number 100)
      (printf "Index where the number 100 first appears: ~a~%" index)
      (set! found #t))))

; Check that the GCD of all two consecutive members up to the 1000th member is always one.

(let ((any-bad #f)
      (gcd (lambda (a b)
             (if (= b 0)
               a
               (gcd b (remainder a b))))))
  (do ((index 1 (1+ index)))
      ((> index 1000))
    (let ((sbgcd (gcd (stern-brocot index) (stern-brocot (1+ index)))))
      (when (not (= 1 sbgcd))
        (printf "GCD of Stern-Brocot ~a and ~a+1 is ~a -- Not 1~%" index index sbgcd)
        (set! any-bad #t))))
  (when (not any-bad)
    (printf "GCDs of all Stern-Brocot consecutive pairs from 1 to 1000 are 1~%")))
