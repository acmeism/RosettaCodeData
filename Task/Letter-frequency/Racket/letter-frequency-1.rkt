#lang racket
(require math)

(define (letter-frequencies ip)
  (count-samples
   (port->list read-char ip)))

(letter-frequencies (open-input-string "abaabdc"))
