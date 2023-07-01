#lang racket/base

(define (squeeze-string s c)
  (let loop ((cs (string->list s)) (squeezing? #f) (l 0) (acc null))
    (cond [(null? cs) (values l (list->string (reverse acc)))]
          [(and squeezing? (char=? (car cs) c)) (loop (cdr cs) #t l acc)]
          [else (loop (cdr cs) (char=? (car cs) c) (add1 l) (cons (car cs) acc))])))

(define (report-squeeze s c)
  (define-values (l′ s′) (squeeze-string s c))
  (printf "Squeezing ~s in «««~a»»» (length ~a)~%" c s (string-length s))
  (printf "Result: «««~a»»» (length ~a)~%~%" s′ l′))

(define (Determine-if-a-string-is-squeezeable)
  (report-squeeze "" #\space)
  (report-squeeze "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln " #\-)
  (report-squeeze "..1111111111111111111111111111111111111111111111111111111111111117777888" #\7)
  (report-squeeze "I never give 'em hell, I just tell the truth, and they think it's hell. " #\.)
  (define truman-sig "                                                    --- Harry S Truman  ")
  (report-squeeze truman-sig #\space)
  (report-squeeze truman-sig #\-)
  (report-squeeze truman-sig #\r))

(module+ main
  (Determine-if-a-string-is-squeezeable))
