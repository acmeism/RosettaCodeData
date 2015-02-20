#lang racket

(define f-word-max-length (make-parameter 80))
(define-struct f-word (str length count-0 count-1))

(define F-Word# (make-hash))
(define (F-Word n)
  (hash-ref!
   F-Word#
   (list (f-word-max-length) n)
   (λ ()
     (match n
      (1 (f-word "1" 1 0 1))
      (2 (f-word "0" 1 1 0))
      ((? number? n)
       (define f-1 (F-Word (- n 1)))
       (define f-2 (F-Word (- n 2)))
       (define length+  (+ (f-word-length f-1) (f-word-length f-2)))
       (define count-0+ (+ (f-word-count-0 f-1) (f-word-count-0 f-2)))
       (define count-1+ (+ (f-word-count-1 f-1) (f-word-count-1 f-2)))
       (define str+
         (if (and (f-word-max-length)
                  (> length+ (f-word-max-length)))
             (format "<string too long (~a)>" length+)
             (string-append (f-word-str f-1) (f-word-str f-2))))
       (f-word str+ length+ count-0+ count-1+))))))

(module+ test
  (require rackunit)
  (check-match (F-Word 4) (f-word "010" _ _ _))
  (check-match (F-Word 5) (f-word "01001" _ _ _))
  (check-match (F-Word 8) (f-word "010010100100101001010" _ _ _)))
