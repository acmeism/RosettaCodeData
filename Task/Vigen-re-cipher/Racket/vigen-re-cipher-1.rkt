#lang racket
(define chr integer->char)
(define ord char->integer)

(define (encrypt msg key)
  (define cleaned
    (list->string
     (for/list ([c (string-upcase msg)]
                #:when (char-alphabetic? c)) c)))
  (list->string
   (for/list ([c cleaned] [k (in-cycle key)])
     (chr (+ (modulo (+ (ord c) (ord k)) 26) (ord #\A))))))

(define (decrypt msg key)
  (list->string
   (for/list ([c msg] [k (in-cycle key)])
     (chr (+ (modulo (- (ord c) (ord k)) 26) (ord #\A))))))

(decrypt (encrypt "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
                  "VIGENERECIPHER")
         "VIGENERECIPHER")
