; Compute the probability of leading digit d (an integer [1,9]) according to Benford's law.

(define benford-probability
  (lambda (d)
    (- (log (1+ d) 10) (log d 10))))

; Determine the distribution of the leading digit of the sequence provided by the given
; generator.  Return as a vector of 10 elements -- the 0th element will always be 0.

(define leading-digit-distribution
  (lambda (seqgen count)
    (let ((digcounts (make-vector 10 0)))
      (do ((index 0 (1+ index)))
          ((>= index count))
        (let* ((value (seqgen))
               (string (format "~a" value))
               (leadchr (string-ref string 0))
               (leaddig (- (char->integer leadchr) (char->integer #\0))))
          (vector-set! digcounts leaddig (1+ (vector-ref digcounts leaddig)))))
      (vector-map (lambda (digcnt) (/ digcnt count)) digcounts))))

; Create a Fibonacci sequence generator.

(define make-fibgen
  (lambda ()
    (let ((fn-2 0) (fn-1 1))
      (lambda ()
        (let ((fn fn-1))
          (set! fn-1 (+ fn-2 fn-1))
          (set! fn-2 fn)
          fn)))))

; Create a sequence generator that returns elements of the given vector.

(define make-vecgen
  (lambda (vector)
    (let ((index 0))
      (lambda ()
        (set! index (1+ index))
        (vector-ref vector (1- index))))))

; Read all the values in the given file into a list.

(define list-read-file
  (lambda (filenm)
    (call-with-input-file filenm
      (lambda (ip)
        (let accrue ((value (read ip)))
          (if (eof-object? value)
            '()
            (cons value (accrue (read ip)))))))))

; Display a table of digit, Benford's law, sequence distribution, and difference.

(define display-table
  (lambda (seqnam seqgen count)
    (printf "~%~3@a ~11@a ~11@a ~11@a~%" "dig" "Benford's" seqnam "difference")
    (let ((dist (leading-digit-distribution seqgen count)))
      (do ((digit 1 (1+ digit)))
          ((> digit 9))
        (let* ((fraction (vector-ref dist digit))
               (benford (benford-probability digit))
               (diff (- fraction benford)))
          (printf "~3d ~11,5f ~11,5f ~11,5f~%" digit benford fraction diff))))))

; Emit tables of various sequence distributions.

(display-table "Fib/1000" (make-fibgen) 1000)
(display-table "Rnd/1T/1M" (lambda () (1+ (random 1000000000000))) 1000000)
(let ((craters (list->vector (list-read-file "moon_craters.lst"))))
  (display-table "Craters/D" (make-vecgen craters) (vector-length craters)))
