#lang racket (require syntax/parse)

(define bars "▁▂▃▄▅▆▇█")
(define bar-count (string-length bars))

(define (sparks str)
  (define ns (map string->number (string-split str #rx"[ ,]" #:repeat? #t)))
  (define mn (apply min ns))
  (define bar-width (/ (- (apply max ns) mn) (- bar-count 1)))
  (apply string (for/list ([n ns]) (string-ref bars (exact-floor (/ (- n mn) bar-width))))))

(sparks "1 2 3 4 5 6 7 8 7 6 5 4 3 2 1")
(sparks "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5")
