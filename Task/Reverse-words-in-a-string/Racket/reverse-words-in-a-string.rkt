#lang racket/base

(require racket/string)

(define (split-reverse str)
  (string-join
   (reverse
    (string-split str))))

(define poem
  "---------- Ice and Fire ------------

fire, in end will world the say Some
ice. in say Some
desire of tasted I've what From
fire. favor who those with hold I

... elided paragraph last ...

Frost Robert -----------------------")


(let ([poem-port (open-input-string poem)])
  (let loop ([l (read-line poem-port)])
    (unless (eof-object? l)
      (begin (displayln (split-reverse l))
              (loop (read-line poem-port))))))
