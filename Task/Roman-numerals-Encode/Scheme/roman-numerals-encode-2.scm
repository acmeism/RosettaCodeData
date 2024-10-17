(define roman-decimal
  '(("M"  . 1000)
    ("CM" . 900)
    ("D"  . 500)
    ("CD" . 400)
    ("C"  . 100)
    ("XC" .  90)
    ("L"  .  50)
    ("XL" .  40)
    ("X"  .  10)
    ("IX" .   9)
    ("V"  .   5)
    ("IV" .   4)
    ("I"  .   1)))

(define (to-roman value)
  (apply string-append
         (let loop ((v value)
                    (decode roman-decimal))
           (let ((r (caar decode))
                 (d (cdar decode)))
             (cond
              ((= v 0) '())
              ((>= v d) (cons r (loop (- v d) decode)))
              (else (loop v (cdr decode))))))))


(let loop ((n '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 25 30 40
                  50 60 69 70 80 90 99 100 200 300 400 500 600 666 700 800 900
                  1000 1009 1444 1666 1945 1997 1999 2000 2008 2010 2011 2500
                  3000 3999)))
  (unless (null? n)
    (printf "~a ~a\n" (car n) (to-roman (car n)))
    (loop (cdr n))))
