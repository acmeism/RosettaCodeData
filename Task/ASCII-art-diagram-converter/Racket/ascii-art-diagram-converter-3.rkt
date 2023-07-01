#lang racket
(require "ascii-art-reader.rkt")
(require "ascii-art-parser.rkt")
(require tests/eli-tester)

(define rfc-1035-header-art
  #<<EOS
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                      ID                       |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    QDCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ANCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    NSCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ARCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
EOS
  )

(define-values (rslt rslt-b/w) (ascii-art->struct rfc-1035-header-art))

(test
 rslt-b/w => 16
 rslt =>
 '((0 15  0 ID)
   (1 15 15 QR)
   (1 14 11 Opcode)
   (1 10 10 AA)
   (1  9  9 TC)
   (1  8  8 RD)
   (1  7  7 RA)
   (1  6  4 Z)
   (1  3  0 RCODE)
   (2 15  0 QDCOUNT)
   (3 15  0 ANCOUNT)
   (4 15  0 NSCOUNT)
   (5 15  0 ARCOUNT)))

(define-ascii-art-structure rfc-1035-header #<<EOS
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                      ID                       |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    QDCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ANCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    NSCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ARCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
EOS
                     )

(define h-bytes
  (bytes-append
   (integer->integer-bytes #x1234 2 #f)
   (integer->integer-bytes #x5678 2 #f)
   (integer->integer-bytes #x9abc 2 #f)
   (integer->integer-bytes #xdef0 2 #f)
   (integer->integer-bytes #xfedc 2 #f)
   (integer->integer-bytes #xba98 2 #f)))

(define h-bytes~
  (bytes-append
   (integer->integer-bytes #x1234 2 #f (not (system-big-endian?)))
   (integer->integer-bytes #x5678 2 #f (not (system-big-endian?)))
   (integer->integer-bytes #x9abc 2 #f (not (system-big-endian?)))
   (integer->integer-bytes #xdef0 2 #f (not (system-big-endian?)))
   (integer->integer-bytes #xfedc 2 #f (not (system-big-endian?)))
   (integer->integer-bytes #xba98 2 #f (not (system-big-endian?)))))

(define h (bytes->rfc-1035-header h-bytes))
(define bytes-h (rfc-1035-header->bytes h))

(define h~ (bytes->rfc-1035-header h-bytes~))
(define bytes-h~ (rfc-1035-header->bytes h~))

(test
 (rfc-1035-header-ID h) => #x1234
 (rfc-1035-header-ARCOUNT h) => #xBA98
 (rfc-1035-header-RCODE h) => 8
 (rfc-1035-header-ID h~) => #x3412
 (rfc-1035-header-ARCOUNT h~) => #x98BA
 (rfc-1035-header-RCODE h~) => 6
 h-bytes => bytes-h
 h-bytes~ => bytes-h~)

(set-rfc-1035-header-RA! h 0)

(set-rfc-1035-header-Z! h 7)
(test
 (rfc-1035-header-Z (bytes->rfc-1035-header (rfc-1035-header->bytes h))) => 7
 (rfc-1035-header-RA (bytes->rfc-1035-header (rfc-1035-header->bytes h))) => 0)
(set-rfc-1035-header-Z! h 15) ;; naughty -- might splat RA
(test
 (rfc-1035-header-Z (bytes->rfc-1035-header (rfc-1035-header->bytes h))) => 7
 (rfc-1035-header-RA (bytes->rfc-1035-header (rfc-1035-header->bytes h))) => 0)
