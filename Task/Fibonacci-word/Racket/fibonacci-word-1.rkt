#lang racket
(provide F-Word gen-F-Word (struct-out f-word) f-word-max-length)
(require "entropy.rkt") ; save Entropy task implementation as "entropy.rkt"

(define f-word-max-length (make-parameter 80))
(define-struct f-word (str length count-0 count-1))
(define (string->f-word str)
  (apply f-word str
         (call-with-values
          (λ ()
            (for/fold
                ((l 0) (zeros 0) (ones 0))
              ((c str))
              (match c
                (#\0 (values (add1 l) (add1 zeros) ones))
                (#\1 (values (add1 l) zeros (add1 ones))))))
          list)))
(define F-Word# (make-hash))

(define (gen-F-Word n #:key-id key-id #:word-1 word-1 #:word-2 word-2 #:merge-fn merge-fn)
  (define sub-F-Word (match-lambda (1 word-1) (2 word-2) ((? number? n) (merge-fn n))))
  (hash-ref! F-Word# (list key-id (f-word-max-length) n) (λ () (sub-F-Word n))))

(define (F-Word n)
  (define f-word-1 (string->f-word "1"))
  (define f-word-2 (string->f-word "0"))
  (define (f-word-merge>2 n)
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
    (f-word str+ length+ count-0+ count-1+))

  (gen-F-Word n
              #:key-id 'words
              #:word-1 f-word-1
              #:word-2 f-word-2
              #:merge-fn f-word-merge>2))

(module+ main
  (parameterize ((f-word-max-length 80))
    (for ((n (sequence-map add1 (in-range 37))))
      (define W (F-Word n))
      (define e (hash-entropy (hash 0 (f-word-count-0 W)
                                    1 (f-word-count-1 W))))
      (printf "~a ~a ~a ~a~%"
              (~a n #:width 3 #:align 'right)
              (~a (f-word-length W) #:width 9 #:align 'right)
              (real->decimal-string e 12)
              (~a (f-word-str W))))))

(module+ test
  (require rackunit)
  (check-match (F-Word 4) (f-word "010" _ _ _))
  (check-match (F-Word 5) (f-word "01001" _ _ _))
  (check-match (F-Word 8) (f-word "010010100100101001010" _ _ _)))
