(import (owl parse))

(define format "
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                      ID                       |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|QR|   Opcode  |AA|TC|RD|RA|    Z   |   RCODE   |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    QDCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ANCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    NSCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ARCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+")
(define (subA x) (- x #\A -1))

(define whitespace (byte-if (lambda (x) (has? '(#\newline #\return #\+ #\- #\|) x))))
(define maybe-whitespaces (greedy* whitespace))

(define format-parser
   (let-parse* (
         (key (greedy* (let-parse* (
               (* maybe-whitespaces)
               (sp1 (greedy* (imm #\space)))
               (name (greedy+ (byte-if (lambda (x) (or (<= #\A x #\Z) (<= #\a x #\z))))))
               (sp2 (greedy* (imm #\space))))
            (cons
               (/ (+ (length sp1) (length name) (length sp2) 1) 3)
               (list->string name)))))
         (* maybe-whitespaces))
      key))

(define table (parse format-parser (str-iter format) #f #f #f))
(unless table
   (print "Invalid template. Exiting.")
   (halt 1))

(print "table structure:" format)
(print "is encoded as " table " ")

(define (decode table data)
   (let loop ((table (reverse table)) (bits data) (out #null))
      (if (null? table)
         out
      else
         (define name (cdar table))
         (define width (caar table))
         (define val (band bits (- (<< 1 width) 1)))

         (loop (cdr table) (>> bits width) (cons (cons name val) out)))))

(define binary-input-data #b011110000100011101111011101111110101010010010110111000010010111000011011111100010110100110100100)
(print "decoding input data " binary-input-data)

(define datastructure (decode table binary-input-data))

(print)
(print "parsed datastructure:")
(for-each (lambda (x)
      (print (car x) " == " (cdr x) " (" (number->string (cdr x) 2) ")"))
   datastructure)
