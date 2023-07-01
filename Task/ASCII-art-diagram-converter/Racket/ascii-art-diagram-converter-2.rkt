#lang racket
(require (for-syntax "ascii-art-parser.rkt"))
(require (for-syntax racket/syntax))

(provide (all-defined-out))

(define-syntax (define-ascii-art-structure stx)
  (syntax-case stx ()
    [(_ id art)
     (let*-values (((all-fields bits/word) (ascii-art->struct (syntax-e #'art))))
       (with-syntax
           ((bytes->id (format-id stx "bytes->~a" #'id))
            (id->bytes (format-id stx "~a->bytes" #'id))
            (word-size (add1 (car (for/last ((f all-fields)) f))))
            (fld-ids (map cadddr all-fields))

            (fld-setters
             (cons
              #'id
              (for/list ((fld (in-list all-fields)))
                (let* ((bytes/word (quotient bits/word 8))
                       (start-byte (let ((word-no (car fld))) (* word-no bytes/word))))
                  `(bitwise-bit-field (integer-bytes->integer bs
                                                              #f
                                                              (system-big-endian?)
                                                              ,start-byte
                                                              ,(+ start-byte bytes/word))
                                      ,(caddr fld)
                                      ,(add1 (cadr fld)))))))

            (set-fields-bits
             (list*
              'begin
              (for/list ((fld (in-list all-fields)))
                (define val (cadddr fld))
                (define start-bit (cadr fld))
                (define end-bit (caddr fld))
                (define start-byte (let ((word-no (car fld))) (* word-no (quotient bits/word 8))))
                (define fld-bit-width (- start-bit end-bit -1))
                (define aligned?/width (and (= end-bit 0)
                                            (= (modulo start-bit 8) 7)
                                            (quotient fld-bit-width 8)))
                (case aligned?/width
                  [(2 4)
                   `(integer->integer-bytes ,val
                                            ,aligned?/width
                                            #f
                                            (system-big-endian?)
                                            rv
                                            ,start-byte)]
                  [else
                   (define the-byte (+ start-byte (quotient end-bit 8)))
                   `(bytes-set! rv
                                ,the-byte
                                (bitwise-ior (arithmetic-shift (bitwise-bit-field ,val 0 ,fld-bit-width)
                                                               ,(modulo end-bit 8))
                                             (bytes-ref rv ,the-byte)))])))))
         #`(begin
             (struct id fld-ids #:mutable)

             (define (bytes->id bs)
               fld-setters)

             (define (id->bytes art-in)
               (match-define (id #,@#'fld-ids) art-in)
               (define rv (make-bytes (* word-size #,(quotient bits/word 8))))
               set-fields-bits
               rv))))]))
