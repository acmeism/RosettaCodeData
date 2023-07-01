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
