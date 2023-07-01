; Return the n'th Bernoulli number.

(define bernoulli
  (lambda (n)
    (let ((a (make-vector (1+ n))))
      (do ((m 0 (1+ m)))
          ((> m n))
        (vector-set! a m (/ 1 (1+ m)))
        (do ((j m (1- j)))
            ((< j 1))
          (vector-set! a (1- j) (* j (- (vector-ref a (1- j)) (vector-ref a j))))))
      (vector-ref a 0))))

; Convert a rational to a string.  If an integer, ends with "/1".

(define rational->string
  (lambda (rational)
    (format "~a/~a" (numerator rational) (denominator rational))))

; Returns the string length of the numerator of a rational.

(define rational-numerator-length
  (lambda (rational)
    (string-length (format "~a" (numerator rational)))))

; Formats a rational with left-padding such that total length to the slash is as given.

(define rational-padded
  (lambda (rational total-length-to-slash)
    (let* ((length-padding (- total-length-to-slash (rational-numerator-length rational)))
           (padding-string (make-string length-padding #\ )))
      (string-append padding-string (rational->string rational)))))

; Return the Bernoulli numbers 0 through n in a list.

(define make-bernoulli-list
  (lambda (n)
    (if (= n 0)
      (list (bernoulli n))
      (append (make-bernoulli-list (1- n)) (list (bernoulli n))))))

; Print the non-zero Bernoulli numbers 0 through 60 aligning the slashes.

(let* ((bernoullis-list (make-bernoulli-list 60))
       (numerator-lengths (map rational-numerator-length bernoullis-list))
       (max-numerator-length (apply max numerator-lengths)))
  (let print-bernoulli ((index 0) (numbers bernoullis-list))
    (cond
      ((null? numbers))
      ((= 0 (car numbers))
        (print-bernoulli (1+ index) (cdr numbers)))
      (else
        (printf "B(~2@a) = ~a~%" index (rational-padded (car numbers) max-numerator-length))
        (print-bernoulli (1+ index) (cdr numbers))))))
