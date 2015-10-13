#lang racket

(require racket/fixnum)

(define (make-bit-writer file)
  (define o (open-output-file file #:exists 'truncate))
  (define b+len (cons 0 0))
  (define (write-some-bits! n len)
    (if (<= 8 len)
      (begin (write-byte (fxand n #xFF) o)
             (write-some-bits! (fxrshift n 8) (- len 8)))
      (set! b+len (cons n len))))
  (define write-bits
    (case-lambda
      [(n) (if (eof-object? n)
             (begin (when (positive? (cdr b+len)) (write-byte (car b+len) o))
                    (close-output-port o))
             (write-bits n (integer-length n)))]
      [(n nbits)
       (when (< nbits (integer-length n))
         (error 'write-bits "integer bigger than number of bits"))
       (write-some-bits! (fxior (car b+len) (fxlshift n (cdr b+len)))
                         (+ (cdr b+len) nbits))]))
  write-bits)

(define (make-bit-reader file)
  (define i (open-input-file file))
  (define b+len (cons 0 0))
  (define (read-some-bits wanted n len)
    (if (<= wanted len)
      (begin0 (fxand n (sub1 (expt 2 wanted)))
        (set! b+len (cons (fxrshift n wanted) (- len wanted))))
      (read-some-bits wanted (+ n (fxlshift (read-byte i) len)) (+ len 8))))
  (define (read-bits n)
    (if (eof-object? n)
      (close-input-port i)
      (read-some-bits n (car b+len) (cdr b+len))))
  read-bits)

(define (crunch str file)
  (define out (make-bit-writer file))
  (for ([b (in-bytes (string->bytes/utf-8 str))]) (out b 7))
  (out eof))

(define (decrunch file)
  (define in (make-bit-reader file))
  (define bs (for/list ([i (in-range (quotient (* 8 (file-size file)) 7))])
               (in 7)))
  (in eof)
  (bytes->string/utf-8 (list->bytes bs)))

(define orig
  (string-append "This is an ascii string that will be"
                 " crunched, written, read and expanded."))

(crunch orig "crunched.out")

(printf "Decrunched string ~aequal to original.\n"
        (if (equal? orig (decrunch "crunched.out")) "" "NOT "))
