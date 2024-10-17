; Procedure to compute factorial.

(define fact
  (lambda (n)
    (if (<= n 0)
      1
      (* n (fact (1- n))))))

; Use series to compute approximation to Pi (using N terms of series).
; (Uses the Newton / Euler Convergence Transformation.)

(define pi-series
  (lambda (n)
    (do ((k 0 (1+ k))
         (sum 0 (+ sum (/ (* (expt 2 k) (expt (fact k) 2)) (fact (1+ (* 2 k)))))))
        ((>= k n) (* 2 sum)))))

; Use series to compute approximation to exp(z) (using N terms of series).

(define exp-series
  (lambda (z n)
    (do ((k 0 (1+ k))
         (sum 0 (+ sum (/ (expt z k) (fact k)))))
        ((>= k n) sum))))

; Convert the given Rational number to a Decimal string.
; If opt contains an integer, show to that many places past the decimal regardless of repeating.
; If opt contains 'nopar, do not insert the parentheses indicating the repeating places.
; If opt contains 'plus, prefix positive numbers with plus ('+') sign.
; N.B.:  When number of decimals specified, this truncates instead of rounds.

(define rat->dec-str
  (lambda (rat . opt)
    (let* ((num (abs (numerator rat)))
           (den (abs (denominator rat)))
           (no-par (find (lambda (a) (eq? a 'nopar)) opt))
           (plus (find (lambda (a) (eq? a 'plus)) opt))
           (dec-lim (find integer? opt))
           (rep-inx #f)
           (rems-seen '())
           (int-part (format (cond ((< rat 0) "-~d") (plus "+~d") (else "~d")) (quotient num den)))
           (frc-list
             (cond
               ((zero? num)
                 '())
               (else
                 (let loop ((rem (modulo num den)) (decs 0))
                   (cond
                     ((or (<= rem 0) (and dec-lim (>= decs dec-lim)))
                       '())
                     ((and (not dec-lim) (assq rem rems-seen))
                       (set! rep-inx (cdr (assq rem rems-seen)))
                       '())
                     (else
                       (set! rems-seen (cons (cons rem decs) rems-seen))
                       (cons
                         (integer->char (+ (quotient (* 10 rem) den) (char->integer #\0)))
                         (loop (modulo (* 10 rem) den) (1+ decs))))))))))
      (when (and rep-inx (not no-par))
        (set! frc-list (append
                         (list-head frc-list rep-inx)
                         (list #\()
                         (list-tail frc-list rep-inx)
                         (list #\)))))
      (if (null? frc-list)
        int-part
        (format "~a.~a" int-part (list->string frc-list))))))

; Convert the given Rational Complex number to a Decimal string.
; If opt contains an integer, show to that many places past the decimal regardless of repeating.
; If opt contains 'nopar, do not insert the parentheses indicating the repeating places.
; If opt contains 'plus, prefix positive numbers with plus ('+') sign.
; N.B.:  When number of decimals specified, this truncates instead of rounds.

(define rat-cplx->dec-str
  (lambda (rat-cplx . opt)
    (let* ((real-dec-str (apply rat->dec-str (cons (real-part rat-cplx) opt)))
           (imag-dec-str (apply rat->dec-str (cons (imag-part rat-cplx) (cons 'plus opt)))))
      (format "~a~ai" real-dec-str imag-dec-str))))

; Print the value of e^(i*pi) + 1 -- should be 0.
; (Computed using the series defined above.)

(let*
    ((pi (pi-series 222))
     (e-pi-i (exp-series (* pi +i) 222))
     (euler-id (+ e-pi-i 1)))
  (printf "e^(i*pi) + 1 = ~a~%" (rat-cplx->dec-str euler-id 70)))
