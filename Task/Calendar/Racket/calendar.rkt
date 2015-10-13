#lang racket
(require racket/date net/base64 file/gunzip)
(define (calendar yr)
  (define (nsplit n l) (if (null? l) l (cons (take l n) (nsplit n (drop l n)))))
  (define months
    (for/list ([mn (in-naturals 1)]
               [mname '(January February March April May June July
                        August September October November December)])
      (define s (find-seconds 0 0 12 1 mn yr))
      (define pfx (date-week-day (seconds->date s)))
      (define days
        (let ([? (if (= mn 12) (λ(x y) y) (λ(x y) x))])
          (round (/ (- (find-seconds 0 0 12 1 (? (+ 1 mn) 1) (? yr (+ 1 yr))) s)
                    60 60 24))))
      (list* (~a mname #:width 20 #:align 'center) "Su Mo Tu We Th Fr Sa"
             (map string-join
                  (nsplit 7 `(,@(make-list pfx "  ")
                              ,@(for/list ([d days])
                                  (~a (+ d 1) #:width 2 #:align 'right))
                              ,@(make-list (- 42 pfx days) "  ")))))))
  (let ([s #"nZA7CsAgDED3nCLgoAU/3Uvv4SCE3qKD5OyNWvoBhdIHSswjMYp4YR2z80Tk8StOgP
             sY0EyrMZOE6WsL3u4G5lyV+d8MyVOy8hZBt7RSMca9Ac/KUIs1L/BOysb50XMtMzEj
             ZqiuRxIVqI+4kSpy7GqpXNsz+bfpfWIGOAA="]
        [o (open-output-string)])
    (inflate (open-input-bytes (base64-decode s)) o)
    (display (regexp-replace #rx"~a" (get-output-string o) (~a yr))))
  (for-each displayln
    (dropf-right (for*/list ([3ms (nsplit 3 months)] [s (apply map list 3ms)])
                   (regexp-replace #rx" +$" (string-join s "   ") ""))
                 (λ(s) (equal? "" s)))))

(calendar 1969)
