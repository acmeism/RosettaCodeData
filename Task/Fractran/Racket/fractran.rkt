#lang racket

(define (displaysp x)
  (display x)
  (display " "))

(define (read-string-list str)
  (map string->number
       (string-split (string-replace str " " "") ",")))

(define (eval-fractran n list)
  (for/or ([e (in-list list)])
    (let ([en (* e n)])
      (and (integer? en) en))))

(define (show-fractran fr n s)
  (printf "First ~a members of fractran(~a):\n" s n)
  (displaysp n)
  (for/fold ([n n]) ([i (in-range (- s 1))])
    (let ([new-n (eval-fractran n fr)])
      (displaysp new-n)
      new-n))
  (void))

(define fractran
  (read-string-list
   (string-append "17 / 91, 78 / 85, 19 / 51, 23 / 38, 29 / 33,"
                  "77 / 29, 95 / 23, 77 / 19, 1 / 17, 11 / 13,"
                  "13 / 11, 15 / 14, 15 / 2, 55 / 1")))

(show-fractran fractran 2 15)
