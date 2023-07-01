#lang racket
(define (bytes-crc32 data)
  (bitwise-xor
   (for/fold ([accum #xFFFFFFFF])
     ([byte  (in-bytes data)])
     (for/fold ([accum (bitwise-xor accum byte)])
       ([num (in-range 0 8)])
       (bitwise-xor (quotient accum 2)
                    (* #xEDB88320 (bitwise-and accum 1)))))
   #xFFFFFFFF))

(define (crc32 s)
  (bytes-crc32 (string->bytes/utf-8 s)))

(format "~x" (crc32 "The quick brown fox jumps over the lazy dog"))
