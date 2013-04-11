#!/bin/env racket
#lang racket/base

(define (run i o)
  (for ([ch (in-producer regexp-match #f #rx#"[a-zA-Z]" i 0 #f o)])
    (define b (bytes-ref (car ch) 0))
    (define a (if (< b 96) 65 97))
    (write-byte (+ (modulo (+ 13 (- b a)) 26) a))))

(require racket/cmdline)
(command-line
 #:help-labels "(\"-\" specifies standard input)"
 #:args files
 (for ([f (if (null? files) '("-") files)])
   (if (equal? f "-")
     (run (current-input-port) (current-output-port))
     (call-with-input-file f ( (i) (run i (current-output-port)))))))
