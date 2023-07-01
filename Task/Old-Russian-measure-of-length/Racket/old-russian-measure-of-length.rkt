#lang racket

(define units
  '([tochka        0.000254]
    [liniya        0.00254]
    [diuym         0.0254]
    [vershok       0.04445]
    [piad          0.1778]
    [fut           0.3048]
    [arshin        0.7112]
    [sazhen        2.1336]
    [versta     1066.8]
    [milia      7467.6]
    [centimeter    0.01]
    [meter         1.0]
    [kilometer  1000.0]))

(define (show u)
  (printf "1 ~s to:\n" u)
  (define n (cadr (assq u units)))
  (for ([u2 units] #:unless (eq? u (car u2)))
    (displayln (~a (~a (car u2) #:width 10 #:align 'right) ": "
                   (~r (/ n (cadr u2)) #:precision 4))))
  (newline))

(show 'meter)
(show 'milia)
